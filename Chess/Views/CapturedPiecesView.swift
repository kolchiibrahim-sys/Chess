//
//  CapturedPiecesView.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

final class CapturedPiecesView: UIView {

    private let stack = UIStackView()
    private let scoreLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {

        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center

        scoreLabel.font = .systemFont(ofSize: 14, weight: .bold)
        scoreLabel.textColor = .secondaryLabel

        let container = UIStackView(arrangedSubviews: [stack, scoreLabel])
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center

        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with pieces: [ChessPiece], score: Int) {

        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        pieces.forEach { piece in
            let iv = UIImageView(image: UIImage(named: "\(piece.color.rawValue)_\(piece.type.rawValue)"))
            iv.contentMode = .scaleAspectFit
            iv.widthAnchor.constraint(equalToConstant: 18).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 18).isActive = true
            stack.addArrangedSubview(iv)
        }

        scoreLabel.text = score > 0 ? "+\(score)" : ""
    }
}
