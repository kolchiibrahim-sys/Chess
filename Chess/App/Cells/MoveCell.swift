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

        backgroundColor = .clear
        selectionStyle = .none

        numberLabel.font = .boldSystemFont(ofSize: 13)
        numberLabel.textColor = .secondaryLabel
        numberLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        whiteLabel.font = .systemFont(ofSize: 15, weight: .medium)
        blackLabel.font = .systemFont(ofSize: 15, weight: .medium)

        let stack = UIStackView(arrangedSubviews: [
            numberLabel,
            whiteLabel,
            blackLabel
        ])

        stack.spacing = 6
        stack.alignment = .center

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(move: MoveRecord, row: Int) {
        numberLabel.text = "\(row + 1)."
        whiteLabel.text = move.whiteMove ?? "-"
        blackLabel.text = move.blackMove ?? ""
    }
}
