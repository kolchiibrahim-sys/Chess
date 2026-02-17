//
//  PromotionView.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

final class PromotionView: UIView {

    var onSelect: ((PromotionOption) -> Void)?

    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {

        backgroundColor = UIColor.black.withAlphaComponent(0.6)

        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.alignment = .center

        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16

        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.heightAnchor.constraint(equalToConstant: 90),
            container.widthAnchor.constraint(equalToConstant: 280),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])

        PromotionOption.allCases.forEach { option in
            let button = createButton(for: option)
            stack.addArrangedSubview(button)
        }
    }

    private func createButton(for option: PromotionOption) -> UIButton {

        let button = UIButton(type: .system)
        button.tag = PromotionOption.allCases.firstIndex(of: option) ?? 0

        let imageName = "white_\(option.pieceType.rawValue)"
        button.setImage(UIImage(named: imageName), for: .normal)

        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)

        return button
    }

    @objc private func tapped(_ sender: UIButton) {
        let option = PromotionOption.allCases[sender.tag]
        onSelect?(option)
        removeFromSuperview()
    }
}
