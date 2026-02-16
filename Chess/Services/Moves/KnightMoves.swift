//
//  KnightMoves.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

enum KnightMoves {

    static func moves(for piece: ChessPiece,
                      pieces: [ChessPiece]) -> [(Int, Int)] {

        var moves: [(Int, Int)] = []

        let possibleOffsets = [
            (-2, -1), (-2, 1),
            (2, -1),  (2, 1),
            (-1, -2), (-1, 2),
            (1, -2),  (1, 2)
        ]

        for offset in possibleOffsets {
            let newRow = piece.row + offset.0
            let newCol = piece.col + offset.1

            if !isInsideBoard(row: newRow, col: newCol) { continue }

            if isFriendly(row: newRow, col: newCol, piece: piece, pieces: pieces) {
                continue
            }

            moves.append((newRow, newCol))
        }

        return moves
    }
}
private extension KnightMoves {

    static func isInsideBoard(row: Int, col: Int) -> Bool {
        row >= 0 && row < 8 && col >= 0 && col < 8
    }

    static func isFriendly(row: Int,
                           col: Int,
                           piece: ChessPiece,
                           pieces: [ChessPiece]) -> Bool {

        pieces.contains {
            $0.row == row &&
            $0.col == col &&
            $0.color == piece.color
        }
    }
}
