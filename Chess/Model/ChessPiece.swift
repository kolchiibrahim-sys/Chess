//
//  ChessPiece.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
import Foundation

enum PieceType: String, Codable {
    case king, queen, rook, bishop, knight, pawn
}

enum PieceColor: String, Codable {
    case white, black
}

struct ChessPiece: Codable {
    let type: PieceType
    let color: PieceColor
    let row: Int
    let col: Int
}
