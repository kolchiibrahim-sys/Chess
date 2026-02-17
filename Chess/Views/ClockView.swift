//
//  ClockView.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//

import UIKit

final class ClockView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        layer.cornerRadius = 8

        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func setTime(_ text: String) {
        label.text = text
    }
}
