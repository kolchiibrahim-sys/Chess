//
//  EnPassant.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import Foundation

final class EnPassantManager {

    static let shared = EnPassantManager()
    private init() {}

    var targetSquare: (row:Int, col:Int)?
    var pawnToCapture: ChessPiece?

    func registerDoublePawnMove(piece: ChessPiece, fromRow: Int, toRow: Int) {

        clear()

        guard piece.type == .pawn else { return }

        if abs(fromRow - toRow) == 2 {
            targetSquare = ((fromRow + toRow) / 2, piece.col)
            pawnToCapture = piece
        }
    }

    func clear() {
        targetSquare = nil
        pawnToCapture = nil
    }
}
