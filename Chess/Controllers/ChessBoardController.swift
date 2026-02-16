//
//  ChessBoardController.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import UIKit

final class ChessBoardController: UIViewController {

    private let viewModel = ChessBoardViewModel()
    private let boardView = ChessBoardView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        setupCollection()
        bindViewModel()
        viewModel.fetchBoard()

        SoundManager.shared.gameStart()
    }

    // MARK: - UI

    private func setupUI() {
        view.addSubview(boardView)
        boardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor)
        ])
    }

    private func setupCollection() {
        let collection = boardView.collection

        collection.backgroundColor = .clear
        collection.register(ChessCell.self, forCellWithReuseIdentifier: ChessCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
    }

    private func bindViewModel() {

        viewModel.reloadBoard = { [weak self] in
            self?.updateTitle()
            self?.boardView.collection.reloadData()
        }

        viewModel.didMovePiece = { [weak self] r1,c1,r2,c2 in
            self?.animateMove(from: (r1,c1), to: (r2,c2))
        }
    }

    // MARK: - Title updates

    private func updateTitle() {

        if let winner = viewModel.checkmateWinner {
            title = "CHECKMATE 👑 \(winner == .white ? "White" : "Black") wins"
            return
        }

        if let color = viewModel.kingInCheck {
            title = "CHECK ⚠️ \(color == .white ? "White" : "Black") king"
        } else {
            title = "Chess ♟️"
        }
    }

    // MARK: - Animation

    private func animateMove(from old:(Int,Int), to new:(Int,Int)) {

        let collection = boardView.collection
        let fromIndex = IndexPath(item: old.0 * 8 + old.1, section: 0)
        let toIndex = IndexPath(item: new.0 * 8 + new.1, section: 0)

        guard let fromCell = collection.cellForItem(at: fromIndex) else {
            collection.reloadData()
            return
        }

        let snapshot = fromCell.snapshotView(afterScreenUpdates: false)!
        snapshot.frame = fromCell.convert(fromCell.bounds, to: view)
        view.addSubview(snapshot)

        fromCell.alpha = 0

        UIView.animate(withDuration: 0.35, animations: {
            if let toCell = collection.cellForItem(at: toIndex) {
                snapshot.frame = toCell.convert(toCell.bounds, to: self.view)
            }
        }) { _ in
            snapshot.removeFromSuperview()
            collection.reloadData()
        }
    }
}
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
            viewModel.possibleMoves.contains { $0.row == row && $0.col == col }

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
extension ChessBoardController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.item / 8
        let col = indexPath.item % 8
        viewModel.selectPiece(at: row, col: col)
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
