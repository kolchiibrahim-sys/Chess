//
//  ChessEngine.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

final class ChessEngine {

    static let shared = ChessEngine()
    private init() {}

    func possibleMoves(for piece: ChessPiece,
                       pieces: [ChessPiece]) -> [(row: Int, col: Int)] {

        switch piece.type {

        case .pawn:
            return PawnMoves.moves(for: piece, pieces: pieces)

        case .rook:
            return RookMoves.moves(for: piece, pieces: pieces)

        case .knight:
            return KnightMoves.moves(for: piece, pieces: pieces)

        case .bishop:
            return BishopMoves.moves(for: piece, pieces: pieces)

        case .queen:
            return QueenMoves.moves(for: piece, pieces: pieces)

        case .king:
            let normalMoves = KingMoves.moves(for: piece, pieces: pieces)
            let castling = CastlingMoves.moves(for: piece, pieces: pieces)
            return normalMoves + castling
        }
    }
}
