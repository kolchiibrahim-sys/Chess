//
//  ChessBoardController.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import UIKit

final class ChessBoardController: UIViewController {

    private let viewModel = ChessBoardViewModel()

    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(ChessCell.self, forCellWithReuseIdentifier: ChessCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chess ♟️"
        view.backgroundColor = .systemBackground

        setupUI()
        bindViewModel()
        viewModel.fetchBoard()
    }

    private func setupUI() {
        view.addSubview(collection)

        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            collection.heightAnchor.constraint(equalTo: collection.widthAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.reloadBoard = { [weak self] in
            self?.collection.reloadData()
        }
    }
}

// MARK: - DataSource
extension ChessBoardController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        64
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChessCell.identifier,
            for: indexPath
        ) as! ChessCell

        let row = indexPath.item / 8
        let col = indexPath.item % 8

        let piece = viewModel.piece(at: row, col: col)

        let isSelected =
            viewModel.selectedPiece?.row == row &&
            viewModel.selectedPiece?.col == col

        let isPossibleMove =
            viewModel.possibleMoves.contains(where: { $0.row == row && $0.col == col })

        let isKingInCheck = viewModel.isKingCell(row: row, col: col)

        cell.configure(
            row: row,
            col: col,
            piece: piece,
            isSelected: isSelected,
            isPossibleMove: isPossibleMove,
            isKingInCheck: isKingInCheck
        )

        return cell
    }
}

extension ChessBoardController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let boardSize = collectionView.bounds.width
        let cellSize = floor(boardSize / 8)
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Selection
extension ChessBoardController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let row = indexPath.item / 8
        let col = indexPath.item % 8

        viewModel.selectPiece(at: row, col: col)
      
    }
}
