//
//  ChessBoardViewModel.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

final class ChessBoardViewModel {

    // MARK: - Properties

    private(set) var pieces: [ChessPiece] = []
    private(set) var selectedPiece: ChessPiece?

    var reloadBoard: (() -> Void)?

    // MARK: - Fetch (Mock API)

    func fetchBoard() {
        LocalNetworkManager.shared.fetchBoard { [weak self] result in
            switch result {
            case .success(let pieces):
                self?.pieces = pieces
                DispatchQueue.main.async {
                    self?.reloadBoard?()
                }

            case .failure(let error):
                print("Fetch error:", error)
            }
        }
    }

    // MARK: - Helpers

    func piece(at row: Int, col: Int) -> ChessPiece? {
        pieces.first { $0.row == row && $0.col == col }
    }

    // MARK: - Selection

    func selectPiece(at row: Int, col: Int) {
        if let piece = piece(at: row, col: col) {
            selectedPiece = piece
        } else {
            selectedPiece = nil
        }

        reloadBoard?() // selection dəyişəndə board yenilənsin
    }
}
