//
//  ChessBoardController.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
import UIKit

final class ChessBoardController: UIViewController {

    private let viewModel = ChessBoardViewModel()
    private let whiteClock = ClockView()
    private let blackClock = ClockView()
    private let boardView = ChessBoardView()
    private let capturedTop = CapturedPiecesView()
    private let capturedBottom = CapturedPiecesView()
    private let historyView = MoveHistoryView()
    private let promotionView = PromotionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupCollection()
        bindViewModel()
        viewModel.fetchBoard()
        SoundManager.shared.gameStart()
        BoardAnimator.flip(boardView.collection, for: .white)
        ChessClockManager.shared.start(turn: .white)
    }

    private func setupUI() {
        view.addSubview(capturedTop)
        view.addSubview(boardView)
        view.addSubview(capturedBottom)
        view.addSubview(historyView)
        view.addSubview(whiteClock)
        view.addSubview(blackClock)

        capturedTop.translatesAutoresizingMaskIntoConstraints = false
        boardView.translatesAutoresizingMaskIntoConstraints = false
        capturedBottom.translatesAutoresizingMaskIntoConstraints = false
        historyView.translatesAutoresizingMaskIntoConstraints = false
        whiteClock.translatesAutoresizingMaskIntoConstraints = false
        blackClock.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            capturedTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            capturedTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            capturedTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            capturedTop.heightAnchor.constraint(equalToConstant: 40),

            blackClock.trailingAnchor.constraint(equalTo: capturedTop.trailingAnchor),
            blackClock.centerYAnchor.constraint(equalTo: capturedTop.centerYAnchor),

            boardView.topAnchor.constraint(equalTo: capturedTop.bottomAnchor, constant: 8),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor),

            capturedBottom.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 8),
            capturedBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            capturedBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            capturedBottom.heightAnchor.constraint(equalToConstant: 40),

            whiteClock.trailingAnchor.constraint(equalTo: capturedBottom.trailingAnchor),
            whiteClock.centerYAnchor.constraint(equalTo: capturedBottom.centerYAnchor),

            historyView.topAnchor.constraint(equalTo: capturedBottom.bottomAnchor, constant: 8),
            historyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

        ChessClockManager.shared.onTick = { [weak self] in
            guard let self else { return }
            self.whiteClock.setTime(ChessClockManager.shared.formattedWhiteTime())
            self.blackClock.setTime(ChessClockManager.shared.formattedBlackTime())
        }

        ChessClockManager.shared.onTimeOver = { [weak self] loser in
            guard let self else { return }
            let winner: PieceColor = loser == .white ? .black : .white
            self.showGameOverAlert(winner: winner)
        }

        viewModel.reloadBoard = { [weak self] in
            guard let self else { return }

            self.updateTitle()
            self.boardView.collection.reloadData()

            BoardAnimator.flip(self.boardView.collection,
                               for: self.viewModel.currentTurn)

            self.capturedTop.configure(
                with: self.viewModel.capturedBlack,
                score: self.viewModel.blackAdvantage
            )

            self.capturedBottom.configure(
                with: self.viewModel.capturedWhite,
                score: self.viewModel.whiteAdvantage
            )

            self.historyView.configure(with: self.viewModel.moveHistory)

            if let winner = self.viewModel.checkmateWinner {
                self.showGameOverAlert(winner: winner)
            }
        }

        viewModel.didMovePiece = { [weak self] r1,c1,r2,c2 in
            self?.animateMove(from: (r1,c1), to: (r2,c2))
        }

        viewModel.showPromotion = { [weak self] in
            guard let self else { return }
            self.view.addSubview(self.promotionView)
            self.promotionView.frame = self.view.bounds
            self.promotionView.onSelect = { option in
                self.viewModel.promotePawn(to: option)
            }
        }
    }

    private func updateTitle() {
        if let color = viewModel.kingInCheck {
            title = "CHECK ⚠️ \(color == .white ? "White" : "Black") king"
        } else {
            title = "Chess ♟️"
        }
    }

    private func showGameOverAlert(winner: PieceColor) {
        let alert = UIAlertController(
            title: "CHECKMATE 👑",
            message: "\(winner == .white ? "White" : "Black") wins!",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "New Game", style: .default) { _ in
            self.viewModel.resetGame()
            ChessClockManager.shared.reset()
            ChessClockManager.shared.start(turn: .white)
        })

        present(alert, animated: true)
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 64 }

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
