//
//  BoardAnimator.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

enum BoardAnimator {

    static func flip(_ collection: UICollectionView,
                     for turn: PieceColor) {

        guard AppSettings.boardFlipEnabled else {
            collection.transform = .identity
            return
        }

        let shouldFlip = turn == .black

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut
        ) {
            collection.transform = shouldFlip
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
        }
    }
}
