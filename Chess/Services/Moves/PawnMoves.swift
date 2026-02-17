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
        let startRow = piece.color == .white ? 6 : 1

        let oneStepRow = piece.row + direction
        let twoStepRow = piece.row + (direction * 2)

        if isInsideBoard(row: oneStepRow, col: piece.col),
           !isOccupied(row: oneStepRow, col: piece.col, pieces: pieces) {
            moves.append((oneStepRow, piece.col))

            if piece.row == startRow &&
               !isOccupied(row: twoStepRow, col: piece.col, pieces: pieces) {
                moves.append((twoStepRow, piece.col))
            }
        }

        let leftCol = piece.col - 1
        let rightCol = piece.col + 1

        if isEnemy(row: oneStepRow, col: leftCol, piece: piece, pieces: pieces) {
            moves.append((oneStepRow, leftCol))
        }

        if isEnemy(row: oneStepRow, col: rightCol, piece: piece, pieces: pieces) {
            moves.append((oneStepRow, rightCol))
        }

        if let target = EnPassantManager.shared.targetSquare {

            if abs(target.col - piece.col) == 1 &&
               target.row == piece.row + direction {
                moves.append(target)
            }
        }

        return moves
    }
}

private extension PawnMoves {

    static func isInsideBoard(row: Int, col: Int) -> Bool {
        row >= 0 && row < 8 && col >= 0 && col < 8
    }

    static func isOccupied(row: Int, col: Int, pieces: [ChessPiece]) -> Bool {
        pieces.contains { $0.row == row && $0.col == col }
    }

    static func isEnemy(row: Int,
                        col: Int,
                        piece: ChessPiece,
                        pieces: [ChessPiece]) -> Bool {

        guard isInsideBoard(row: row, col: col) else { return false }

        return pieces.contains {
            $0.row == row &&
            $0.col == col &&
            $0.color != piece.color
        }
    }
}
