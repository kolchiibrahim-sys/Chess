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

    private let moveDot: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        v.layer.cornerRadius = 8
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        pieceImageView.translatesAutoresizingMaskIntoConstraints = false
        pieceImageView.contentMode = .scaleAspectFit

        contentView.addSubview(pieceImageView)
        contentView.addSubview(moveDot)

        NSLayoutConstraint.activate([
            pieceImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pieceImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pieceImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            pieceImageView.heightAnchor.constraint(equalTo: pieceImageView.widthAnchor),

            moveDot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moveDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moveDot.widthAnchor.constraint(equalToConstant: 16),
            moveDot.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(row: Int,
                   col: Int,
                   piece: ChessPiece?,
                   isSelected: Bool,
                   isPossibleMove: Bool) {

        let isWhite = (row + col) % 2 == 0
        backgroundColor = isWhite
            ? .systemGray5
            : UIColor(red: 118/255, green: 150/255, blue: 86/255, alpha: 1)

        if let piece = piece {
            pieceImageView.image = UIImage(
                named: "\(piece.color.rawValue)_\(piece.type.rawValue)"
            )
        } else {
            pieceImageView.image = nil
        }

        layer.borderWidth = isSelected ? 3 : 0
        layer.borderColor = UIColor.systemYellow.cgColor

        moveDot.isHidden = !isPossibleMove
    }
}
