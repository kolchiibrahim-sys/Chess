//
//  ChessBoardViewModel.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

final class ChessBoardViewModel {

    // MARK: - State

    private(set) var pieces: [ChessPiece] = []
    private(set) var selectedPiece: ChessPiece?
    private(set) var possibleMoves: [(row: Int, col: Int)] = []

    private(set) var currentTurn: PieceColor = .white
    private(set) var kingInCheck: PieceColor?
    private(set) var checkmateWinner: PieceColor?

    // MARK: - Bindings

    var reloadBoard: (() -> Void)?
    var didMovePiece: ((_ r1:Int,_ c1:Int,_ r2:Int,_ c2:Int) -> Void)?

    // MARK: - Fetch Board

    func fetchBoard() {
        LocalNetworkManager.shared.fetchBoard { [weak self] result in
            switch result {
            case .success(let pieces):
                self?.pieces = pieces
                DispatchQueue.main.async {
                    self?.reloadBoard?()
                }
            case .failure(let error):
                print("Fetch error:", error)
            }
        }
    }

    // MARK: - Helpers

    func piece(at row: Int, col: Int) -> ChessPiece? {
        pieces.first { $0.row == row && $0.col == col }
    }

    func isKingCell(row: Int, col: Int) -> Bool {
        guard let color = kingInCheck else { return false }
        return pieces.contains {
            $0.type == .king &&
            $0.color == color &&
            $0.row == row &&
            $0.col == col
        }
    }

    // MARK: - Selection / Move Logic

    func selectPiece(at row: Int, col: Int) {

        // move etmək istəyir?
        if let selected = selectedPiece {
            if possibleMoves.contains(where: { $0.row == row && $0.col == col }) {
                movePiece(to: row, col: col)
                return
            }
        }

        // yeni fiqur seç
        guard let piece = piece(at: row, col: col),
              piece.color == currentTurn else {
            selectedPiece = nil
            possibleMoves.removeAll()
            reloadBoard?()
            return
        }

        selectedPiece = piece
        possibleMoves = ChessEngine.shared.possibleMoves(for: piece, pieces: pieces)
        reloadBoard?()
    }

    // MARK: - MOVE PIECE

    private func movePiece(to row: Int, col: Int) {

        guard let selected = selectedPiece,
              let index = pieces.firstIndex(where: {
                  $0.row == selected.row && $0.col == selected.col
              }) else { return }

        let oldRow = selected.row
        let oldCol = selected.col

        // capture varsa sil
        pieces.removeAll {
            $0.row == row && $0.col == col && $0.color != selected.color
        }

        // fiquru köçür
        pieces[index] = ChessPiece(
            type: selected.type,
            color: selected.color,
            row: row,
            col: col,
            hasMoved: true
        )

        //  move sound
        SoundManager.shared.moveSelf()

        // turn change
        currentTurn = currentTurn == .white ? .black : .white

        // CHECK detection
        if CheckValidator.isKingInCheck(color: .white, pieces: pieces) {
            kingInCheck = .white
            SoundManager.shared.check()
        }
        else if CheckValidator.isKingInCheck(color: .black, pieces: pieces) {
            kingInCheck = .black
            SoundManager.shared.check()
        }
        else {
            kingInCheck = nil
        }

        // CHECKMATE detection
        if CheckmateValidator.isCheckmate(color: .white, pieces: pieces) {
            checkmateWinner = .black
            SoundManager.shared.checkmate()
        }
        if CheckmateValidator.isCheckmate(color: .black, pieces: pieces) {
            checkmateWinner = .white
            SoundManager.shared.checkmate()
        }

        // clean selection
        selectedPiece = nil
        possibleMoves.removeAll()

        // animation trigger
        didMovePiece?(oldRow, oldCol, row, col)

        reloadBoard?()
    }
}
