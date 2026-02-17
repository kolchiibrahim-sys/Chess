//
//  ChessBoardViewModel.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
//
import Foundation

final class ChessBoardViewModel {

    private(set) var pieces: [ChessPiece] = []
    private(set) var selectedPiece: ChessPiece?
    private(set) var possibleMoves: [(row:Int,col:Int)] = []

    private(set) var capturedWhite: [ChessPiece] = []
    private(set) var capturedBlack: [ChessPiece] = []

    private(set) var currentTurn: PieceColor = .white
    private(set) var kingInCheck: PieceColor?
    private(set) var checkmateWinner: PieceColor?

    private(set) var whiteAdvantage: Int = 0
    private(set) var blackAdvantage: Int = 0

    private(set) var promotionPiece: ChessPiece?
    var showPromotion: (() -> Void)?

    var reloadBoard: (() -> Void)?
    var didMovePiece: ((_ r1:Int,_ c1:Int,_ r2:Int,_ c2:Int) -> Void)?

    func fetchBoard() {
        LocalNetworkManager.shared.fetchBoard { [weak self] result in
            switch result {
            case .success(let pieces):
                self?.pieces = pieces
                DispatchQueue.main.async { self?.reloadBoard?() }
            case .failure(let error):
                print("Fetch error:", error)
            }
        }
    }

    func piece(at row: Int, col: Int) -> ChessPiece? {
        pieces.first { $0.row == row && $0.col == col }
    }

    func isKingCell(row: Int, col: Int) -> Bool {
        guard let color = kingInCheck else { return false }
        return pieces.contains {
            $0.type == .king &&
            $0.color == color &&
            $0.row == row &&
            $0.col == col
        }
    }

    func selectPiece(at row: Int, col: Int) {

        if let selected = selectedPiece,
           possibleMoves.contains(where: { $0.row == row && $0.col == col }) {
            movePiece(to: row, col: col)
            return
        }

        guard let piece = piece(at: row, col: col),
              piece.color == currentTurn else {
            selectedPiece = nil
            possibleMoves.removeAll()
            reloadBoard?()
            return
        }

        selectedPiece = piece
        possibleMoves = ChessEngine.shared.possibleMoves(for: piece, pieces: pieces)
        reloadBoard?()
    }

    private func movePiece(to row: Int, col: Int) {

        guard let selected = selectedPiece else { return }

        let oldRow = selected.row
        let oldCol = selected.col

        pieces.removeAll { $0.row == oldRow && $0.col == oldCol }

        if let capturedIndex = pieces.firstIndex(where: { $0.row == row && $0.col == col }) {

            let captured = pieces[capturedIndex]

            if captured.color == .white {
                capturedWhite.append(captured)
            } else {
                capturedBlack.append(captured)
            }

            pieces.remove(at: capturedIndex)
            SoundManager.shared.capture()

        } else {
            SoundManager.shared.moveSelf()
        }

        let movedPiece = ChessPiece(
            type: selected.type,
            color: selected.color,
            row: row,
            col: col,
            hasMoved: true
        )

        pieces.append(movedPiece)

        if PromotionDetector.shouldPromote(movedPiece) {
            promotionPiece = movedPiece
            showPromotion?()
        }

        currentTurn = currentTurn == .white ? .black : .white

        if CheckValidator.isKingInCheck(color: .white, pieces: pieces) {
            kingInCheck = .white
            SoundManager.shared.check()
        }
        else if CheckValidator.isKingInCheck(color: .black, pieces: pieces) {
            kingInCheck = .black
            SoundManager.shared.check()
        }
        else {
            kingInCheck = nil
        }

        if CheckmateValidator.isCheckmate(color: .white, pieces: pieces) {
            checkmateWinner = .black
            SoundManager.shared.gameEnd()
        }

        if CheckmateValidator.isCheckmate(color: .black, pieces: pieces) {
            checkmateWinner = .white
            SoundManager.shared.gameEnd()
        }

        selectedPiece = nil
        possibleMoves.removeAll()

        didMovePiece?(oldRow, oldCol, row, col)

        let advantage = MaterialCalculator.materialAdvantage(pieces: pieces)
        whiteAdvantage = advantage.white
        blackAdvantage = advantage.black

        reloadBoard?()
    }

    func promotePawn(to option: PromotionOption) {
        
        guard let pawn = promotionPiece else { return }
        
        pieces.removeAll {
            $0.row == pawn.row && $0.col == pawn.col
        }
        
        let promoted = PromotionHandler.promote(piece: pawn, to: option)
        pieces.append(promoted)
        
        SoundManager.shared.promote()
        
        promotionPiece = nil
        reloadBoard?()
    }
        func resetGame() {
            
            pieces = GameResetManager.initialBoard()

            capturedWhite.removeAll()
            capturedBlack.removeAll()

            selectedPiece = nil
            possibleMoves.removeAll()

            currentTurn = .white
            kingInCheck = nil
            checkmateWinner = nil

            whiteAdvantage = 0
            blackAdvantage = 0

            SoundManager.shared.gameStart()
            reloadBoard?()
        }

    }

