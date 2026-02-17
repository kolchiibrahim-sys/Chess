//
//  ChessNotationConverter.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import Foundation

enum ChessNotationConverter {

    static func notation(
        piece: ChessPiece,
        fromRow: Int,
        fromCol: Int,
        toRow: Int,
        toCol: Int,
        capture: Bool
    ) -> String {

        let fileLetters = ["a","b","c","d","e","f","g","h"]

        let pieceSymbol: String = {
            switch piece.type {
            case .pawn: return ""
            case .knight: return "N"
            case .bishop: return "B"
            case .rook: return "R"
            case .queen: return "Q"
            case .king: return "K"
            }
        }()

        let destination =
            fileLetters[toCol] + String(8 - toRow)

        if capture {
            if piece.type == .pawn {
                return fileLetters[fromCol] + "x" + destination
            }
            return pieceSymbol + "x" + destination
        }

        return pieceSymbol + destination
    }
}
