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

    // MARK: - RAW MOVES (no check validation)
    // Bu funksiya sadəcə fiqurun necə gedə biləcəyini hesablayır
    func rawMoves(for piece: ChessPiece,
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
            let castlingMoves = CastlingMoves.moves(for: piece, pieces: pieces)
            return normalMoves + castlingMoves
        }
    }

    // MARK: - LEGAL MOVES (king safety)
    // Bu artıq real chess move-lardır
    func possibleMoves(for piece: ChessPiece,
                       pieces: [ChessPiece]) -> [(row: Int, col: Int)] {

        let raw = rawMoves(for: piece, pieces: pieces)

        // Şahı təhlükəyə atan gedişləri silirik
        let safeMoves = raw.filter {
            CheckValidator.isMoveSafe(
                piece: piece,
                toRow: $0.0,
                toCol: $0.1,
                pieces: pieces
            )
        }

        return safeMoves
    }
}
