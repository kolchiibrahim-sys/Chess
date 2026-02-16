//
//  PawnMoves.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//

import Foundation

enum PawnMoves {

    static func moves(for piece: ChessPiece,
                      pieces: [ChessPiece]) -> [(Int, Int)] {

        var moves: [(Int, Int)] = []
        let direction = piece.color == .white ? -1 : 1
        let newRow = piece.row + direction

        let occupied = pieces.contains { $0.row == newRow && $0.col == piece.col }

        if !occupied && newRow >= 0 && newRow < 8 {
            moves.append((newRow, piece.col))
        }

        return moves
    }
}
