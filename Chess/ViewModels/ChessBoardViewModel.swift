//
//  ChessBoardViewModel.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

final class ChessBoardViewModel {

    private(set) var pieces: [ChessPiece] = []
    private(set) var selectedPiece: ChessPiece?
    private(set) var possibleMoves: [(row: Int, col: Int)] = []
    private(set) var currentTurn: PieceColor = .white

    private(set) var kingInCheck: PieceColor?
    private(set) var checkmateWinner: PieceColor?

    var reloadBoard: (() -> Void)?

    // MARK: - Fetch

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

    // MARK: - Selection

    func selectPiece(at row: Int, col: Int) {

        if let selected = selectedPiece,
           possibleMoves.contains(where: { $0.row == row && $0.col == col }) {
            movePiece(to: row, col: col)
            return
        }

        if let piece = piece(at: row, col: col) {

            if piece.color != currentTurn { return }

            selectedPiece = piece
            possibleMoves = ChessEngine.shared.possibleMoves(for: piece, pieces: pieces)

        } else {
            selectedPiece = nil
            possibleMoves.removeAll()
        }

        reloadBoard?()
    }

    // MARK: - Move Logic

    private func movePiece(to row: Int, col: Int) {

        guard let selected = selectedPiece else { return }

        // capture
        if let enemyIndex = pieces.firstIndex(where: {
            $0.row == row && $0.col == col && $0.color != selected.color
        }) {
            pieces.remove(at: enemyIndex)
        }

        // move piece
        if let index = pieces.firstIndex(where: {
            $0.row == selected.row && $0.col == selected.col
        }) {
            pieces[index] = ChessPiece(
                type: selected.type,
                color: selected.color,
                row: row,
                col: col,
                hasMoved: true
            )
        }

        // castling rook move
        if selected.type == .king && abs(col - selected.col) == 2 {

            let rookStartCol = col == 6 ? 7 : 0
            let rookEndCol = col == 6 ? 5 : 3

            if let rookIndex = pieces.firstIndex(where: {
                $0.type == .rook &&
                $0.color == selected.color &&
                $0.row == row &&
                $0.col == rookStartCol
            }) {
                pieces[rookIndex] = ChessPiece(
                    type: .rook,
                    color: selected.color,
                    row: row,
                    col: rookEndCol,
                    hasMoved: true
                )
            }
        }

        // turn change
        currentTurn = currentTurn == .white ? .black : .white
        SoundManager.playMoveSound()

        // CHECK detection
        if CheckValidator.isKingInCheck(color: .white, pieces: pieces) {
            kingInCheck = .white
            SoundManager.playCheckSound()
        }
        else if CheckValidator.isKingInCheck(color: .black, pieces: pieces) {
            kingInCheck = .black
            SoundManager.playCheckSound()
        }
        else {
            kingInCheck = nil
        }

        // CHECKMATE detection
        if CheckmateValidator.isCheckmate(color: .white, pieces: pieces) {
            checkmateWinner = .black
            SoundManager.playCheckmateSound()
        }
        else if CheckmateValidator.isCheckmate(color: .black, pieces: pieces) {
            checkmateWinner = .white
            SoundManager.playCheckmateSound()
        }

        selectedPiece = nil
        possibleMoves.removeAll()
        reloadBoard?()
    }
}
