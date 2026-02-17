//
//  PromotionHandler.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import Foundation

enum PromotionHandler {

    static func promote(
        piece: ChessPiece,
        to option: PromotionOption
    ) -> ChessPiece {

        ChessPiece(
            type: option.pieceType,
            color: piece.color,
            row: piece.row,
            col: piece.col,
            hasMoved: true
        )
    }
}
