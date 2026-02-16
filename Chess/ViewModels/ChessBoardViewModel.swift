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

    var reloadBoard: (() -> Void)?

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

    func piece(at row: Int, col: Int) -> ChessPiece? {
        pieces.first { $0.row == row && $0.col == col }
    }

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

    private func movePiece(to row: Int, col: Int) {

        guard let selected = selectedPiece else { return }

        if let enemyIndex = pieces.firstIndex(where: {
            $0.row == row && $0.col == col && $0.color != selected.color
        }) {
            pieces.remove(at: enemyIndex)
        }

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

        // Castling rook move
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

        currentTurn = currentTurn == .white ? .black : .white

        selectedPiece = nil
        possibleMoves.removeAll()
        reloadBoard?()
    }
}
