//
//  ChessCell.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import UIKit

final class ChessCell: UICollectionViewCell {

    static let identifier = "ChessCell"

    private let pieceImageView = UIImageView()
    private let moveDot = UIView()
    private let highlightView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {

        contentView.addSubview(highlightView)
        contentView.addSubview(pieceImageView)
        contentView.addSubview(moveDot)

        highlightView.translatesAutoresizingMaskIntoConstraints = false
        pieceImageView.translatesAutoresizingMaskIntoConstraints = false
        moveDot.translatesAutoresizingMaskIntoConstraints = false

        pieceImageView.contentMode = .scaleAspectFit

        moveDot.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
        moveDot.layer.cornerRadius = 10
        moveDot.isHidden = true

        NSLayoutConstraint.activate([
            highlightView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            highlightView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            pieceImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pieceImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pieceImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            pieceImageView.heightAnchor.constraint(equalTo: pieceImageView.widthAnchor),

            moveDot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moveDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moveDot.widthAnchor.constraint(equalToConstant: 20),
            moveDot.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(
        row: Int,
        col: Int,
        piece: ChessPiece?,
        isSelected: Bool,
        isPossibleMove: Bool,
        isKingInCheck: Bool,
        isLastMoveFrom: Bool,
        isLastMoveTo: Bool
    ) {

        let isDark = (row + col) % 2 == 1
        contentView.backgroundColor = isDark
            ? UIColor(red: 0.45, green: 0.34, blue: 0.25, alpha: 1)
            : UIColor(red: 0.93, green: 0.85, blue: 0.68, alpha: 1)

        highlightView.backgroundColor = .clear
        layer.borderWidth = 0
        moveDot.isHidden = true

        if let piece {
            pieceImageView.image = UIImage(named: piece.imageName)
        } else {
            pieceImageView.image = nil
        }

        if isLastMoveFrom || isLastMoveTo {
            highlightView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.35)
        }

        if isPossibleMove {
            moveDot.isHidden = false
        }

        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = UIColor.systemBlue.cgColor
        }

        if isKingInCheck {
            layer.borderWidth = 4
            layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}
