//
//  BishopMoves.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

enum BishopMoves {

    static func moves(for piece: ChessPiece,
                      pieces: [ChessPiece]) -> [(Int, Int)] {

        var moves: [(Int, Int)] = []
        let directions = [
            (-1, -1),
            (-1, 1),
            (1, -1),
            (1, 1)
        ]

        for direction in directions {
            moves.append(contentsOf: scanDirection(piece: piece,
                                                   pieces: pieces,
                                                   dRow: direction.0,
                                                   dCol: direction.1))
        }

        return moves
    }
}
private extension BishopMoves {

    static func scanDirection(piece: ChessPiece,
                              pieces: [ChessPiece],
                              dRow: Int,
                              dCol: Int) -> [(Int, Int)] {

        var moves: [(Int, Int)] = []

        var row = piece.row + dRow
        var col = piece.col + dCol

        while isInsideBoard(row: row, col: col) {

            if isFriendly(row: row, col: col, piece: piece, pieces: pieces) {
                break
            }

            if isEnemy(row: row, col: col, piece: piece, pieces: pieces) {
                moves.append((row, col))
                break
            }

            moves.append((row, col))
            row += dRow
            col += dCol
        }

        return moves
    }

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

    static func isEnemy(row: Int,
                        col: Int,
                        piece: ChessPiece,
                        pieces: [ChessPiece]) -> Bool {

        pieces.contains {
            $0.row == row &&
            $0.col == col &&
            $0.color != piece.color
        }
    }
}
