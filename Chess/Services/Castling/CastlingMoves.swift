//
//  CastlingMoves.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import Foundation

enum CastlingMoves {

    static func moves(for king: ChessPiece,
                      pieces: [ChessPiece]) -> [(Int, Int)] {

        guard king.type == .king else { return [] }
        guard !king.hasMoved else { return [] }

        var moves: [(Int, Int)] = []

        let row = king.row
        if let rook = pieces.first(where: {
            $0.type == .rook &&
            $0.color == king.color &&
            $0.row == row &&
            $0.col == 7 &&
            !$0.hasMoved
        }) {

            if isPathEmpty(from: king.col, to: rook.col, row: row, pieces: pieces) {
                moves.append((row, 6))
            }
        }
        if let rook = pieces.first(where: {
            $0.type == .rook &&
            $0.color == king.color &&
            $0.row == row &&
            $0.col == 0 &&
            !$0.hasMoved
        }) {

            if isPathEmpty(from: rook.col, to: king.col, row: row, pieces: pieces) {
                moves.append((row, 2))
            }
        }

        return moves
    }

    private static func isPathEmpty(from: Int,
                                    to: Int,
                                    row: Int,
                                    pieces: [ChessPiece]) -> Bool {

        let minCol = min(from, to) + 1
        let maxCol = max(from, to) - 1

        for col in minCol...maxCol {
            if pieces.contains(where: { $0.row == row && $0.col == col }) {
                return false
            }
        }
        return true
    }
}
