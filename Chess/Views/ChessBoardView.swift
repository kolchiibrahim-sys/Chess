//
//  ChessBoardView.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

final class ChessBoardView: UIView {

    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private let lettersStack = UIStackView()
    private let numbersStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoard()
        setupCoordinates()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup board

    private func setupBoard() {

        addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }

    // MARK: - Letters & Numbers

    private func setupCoordinates() {

        setupLetters()
        setupNumbers()
    }

    private func setupLetters() {

        lettersStack.axis = .horizontal
        lettersStack.distribution = .fillEqually
        lettersStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(lettersStack)

        let letters = ["A","B","C","D","E","F","G","H"]

        letters.forEach { letter in
            let label = UILabel()
            label.text = letter
            label.font = .systemFont(ofSize: 12, weight: .semibold)
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            lettersStack.addArrangedSubview(label)
        }

        NSLayoutConstraint.activate([
            lettersStack.leadingAnchor.constraint(equalTo: collection.leadingAnchor),
            lettersStack.trailingAnchor.constraint(equalTo: collection.trailingAnchor),
            lettersStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            lettersStack.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    private func setupNumbers() {

        numbersStack.axis = .vertical
        numbersStack.distribution = .fillEqually
        numbersStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(numbersStack)

        let numbers = ["8","7","6","5","4","3","2","1"]

        numbers.forEach { number in
            let label = UILabel()
            label.text = number
            label.font = .systemFont(ofSize: 12, weight: .semibold)
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            numbersStack.addArrangedSubview(label)
        }

        NSLayoutConstraint.activate([
            numbersStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            numbersStack.topAnchor.constraint(equalTo: collection.topAnchor),
            numbersStack.bottomAnchor.constraint(equalTo: collection.bottomAnchor),
            numbersStack.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
}
