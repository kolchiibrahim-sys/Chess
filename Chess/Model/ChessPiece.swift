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
    var hasMoved: Bool
    
    enum CodingKeys: String, CodingKey {
        case type, color, row, col, hasMoved
    }
    
    init(type: PieceType,
         color: PieceColor,
         row: Int,
         col: Int,
         hasMoved: Bool = false) {
        
        self.type = type
        self.color = color
        self.row = row
        self.col = col
        self.hasMoved = hasMoved
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(PieceType.self, forKey: .type)
        color = try container.decode(PieceColor.self, forKey: .color)
        row = try container.decode(Int.self, forKey: .row)
        col = try container.decode(Int.self, forKey: .col)
        
        // JSON-da yoxdursa default false olsun
        hasMoved = try container.decodeIfPresent(Bool.self, forKey: .hasMoved) ?? false
    }
}
