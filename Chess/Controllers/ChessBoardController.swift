//
//  ChessBoardController.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
import UIKit

final class ChessBoardController: UIViewController {

    private let viewModel = ChessBoardViewModel()
    private let boardView = ChessBoardView()
    private let capturedTop = CapturedPiecesView()
    private let capturedBottom = CapturedPiecesView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupCollection()
        bindViewModel()
        viewModel.fetchBoard()
        SoundManager.shared.gameStart()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            capturedTop,
            boardView,
            capturedBottom
        ])

        stack.axis = .vertical
        stack.spacing = 12

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor)
        ])
    }

    private func setupCollection() {
        let collection = boardView.collection
        collection.backgroundColor = .clear
        collection.register(ChessCell.self, forCellWithReuseIdentifier: ChessCell.identifier)
        collection.dataSource = self
        collection.delegate = self
    }

    private func bindViewModel() {

        viewModel.reloadBoard = { [weak self] in
            guard let self = self else { return }

            self.updateTitle()
            self.boardView.collection.reloadData()

            self.capturedTop.configure(
                with: self.viewModel.capturedBlack,
                score: self.viewModel.blackAdvantage
            )

            self.capturedBottom.configure(
                with: self.viewModel.capturedWhite,
                score: self.viewModel.whiteAdvantage
            )
        }

        viewModel.didMovePiece = { [weak self] r1,c1,r2,c2 in
            self?.animateMove(from: (r1,c1), to: (r2,c2))
        }
    }

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
