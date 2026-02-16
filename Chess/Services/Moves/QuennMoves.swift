//
//  QuennMoves.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

enum QueenMoves {

    static func moves(for piece: ChessPiece,
                      pieces: [ChessPiece]) -> [(Int, Int)] {

        let rookMoves = RookMoves.moves(for: piece, pieces: pieces)
        let bishopMoves = BishopMoves.moves(for: piece, pieces: pieces)

        return rookMoves + bishopMoves
    }
}
