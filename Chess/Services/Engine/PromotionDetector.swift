//
//  PromotionDetector.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//

import Foundation

enum PromotionDetector {

    static func shouldPromote(_ piece: ChessPiece) -> Bool {

        guard piece.type == .pawn else { return false }

        if piece.color == .white && piece.row == 0 { return true }
        if piece.color == .black && piece.row == 7 { return true }

        return false
    }
}
