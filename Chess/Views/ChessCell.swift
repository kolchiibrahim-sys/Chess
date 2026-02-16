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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerCurve = .continuous
        
        contentView.addSubview(pieceImageView)
        
        NSLayoutConstraint.activate([
            pieceImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pieceImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pieceImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            pieceImageView.heightAnchor.constraint(equalTo: pieceImageView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(row: Int, col: Int, piece: ChessPiece?, isSelected: Bool) {
        
        let isWhite = (row + col) % 2 == 0
        backgroundColor = isWhite
        ? .systemGray5
        : UIColor(red: 118/255, green: 150/255, blue: 86/255, alpha: 1)
        
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = UIColor.systemYellow.cgColor
        } else {
            layer.borderWidth = 0
        }
        
        if let piece = piece {
            let imageName = "\(piece.color.rawValue)_\(piece.type.rawValue)"
            pieceImageView.image = UIImage(named: imageName)
        } else {
            pieceImageView.image = nil
        }
    }
}
