//
//  ChessCell.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import UIKit

final class ChessCell: UICollectionViewCell {

    static let identifier = "ChessCell"

    private let pieceImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let moveDot: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        v.layer.cornerRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

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

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(row: Int,
                   col: Int,
                   piece: ChessPiece?,
                   isSelected: Bool,
                   isPossibleMove: Bool,
                   isKingInCheck: Bool) {

        // Board colors
        let isWhite = (row + col) % 2 == 0
        backgroundColor = isWhite
            ? .systemGray5
            : UIColor(red: 118/255, green: 150/255, blue: 86/255, alpha: 1)

        // Piece image
        if let piece = piece {
            pieceImageView.image = UIImage(named: "\(piece.color.rawValue)_\(piece.type.rawValue)")
        } else {
            pieceImageView.image = nil
        }

        // Possible move dot
        moveDot.isHidden = !isPossibleMove

        // Border priority: CHECK > SELECTED > NONE
        if isKingInCheck {
            layer.borderWidth = 4
            layer.borderColor = UIColor.systemRed.cgColor
        }
        else if isSelected {
            layer.borderWidth = 3
            layer.borderColor = UIColor.systemYellow.cgColor
        }
        else {
            layer.borderWidth = 0
        }
    }
}
