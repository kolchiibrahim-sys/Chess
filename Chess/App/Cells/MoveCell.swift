//
//  MoveCell.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

final class MoveCell: UITableViewCell {

    private let numberLabel = UILabel()
    private let whiteLabel = UILabel()
    private let blackLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        numberLabel.font = .boldSystemFont(ofSize: 14)
        numberLabel.textColor = .secondaryLabel

        whiteLabel.font = .systemFont(ofSize: 16, weight: .medium)
        blackLabel.font = .systemFont(ofSize: 16, weight: .medium)

        let stack = UIStackView(arrangedSubviews: [
            numberLabel, whiteLabel, blackLabel
        ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(move: MoveRecord, index: Int) {
        numberLabel.text = "\(index + 1)."
        whiteLabel.text = move.whiteMove ?? "-"
        blackLabel.text = move.blackMove ?? "-"
    }
}
