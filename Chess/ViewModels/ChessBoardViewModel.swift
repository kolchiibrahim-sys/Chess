//
//  ChessBoardViewModel.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 16.02.26.
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

    private(set) var moveHistory: [MoveRecord] = []
    private var pendingWhiteMove: String?

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

    private func performCastlingIfNeeded(king: ChessPiece, fromCol: Int, toCol: Int, row: Int) {

        if abs(fromCol - toCol) != 2 { return }

        if toCol == 6 {
            if let rookIndex = pieces.firstIndex(where: { $0.type == .rook && $0.row == row && $0.col == 7 }) {
                let rook = pieces.remove(at: rookIndex)
                pieces.append(ChessPiece(type: .rook, color: rook.color, row: row, col: 5, hasMoved: true))
            }
        } else if toCol == 2 {
            if let rookIndex = pieces.firstIndex(where: { $0.type == .rook && $0.row == row && $0.col == 0 }) {
                let rook = pieces.remove(at: rookIndex)
                pieces.append(ChessPiece(type: .rook, color: rook.color, row: row, col: 3, hasMoved: true))
            }
        }

        SoundManager.shared.castle()
    }

    private func movePiece(to row: Int, col: Int) {

        guard let selected = selectedPiece else { return }

        let oldRow = selected.row
        let oldCol = selected.col

        var isCapture = false

        if let target = EnPassantManager.shared.targetSquare,
           target.row == row && target.col == col,
           let pawn = EnPassantManager.shared.pawnToCapture {

            pieces.removeAll { $0.row == pawn.row && $0.col == pawn.col }
            pawn.color == .white ? capturedWhite.append(pawn) : capturedBlack.append(pawn)
            SoundManager.shared.capture()
            isCapture = true
        }

        pieces.removeAll { $0.row == oldRow && $0.col == oldCol }

        if let capturedIndex = pieces.firstIndex(where: { $0.row == row && $0.col == col }) {
            let captured = pieces[capturedIndex]
            captured.color == .white ? capturedWhite.append(captured) : capturedBlack.append(captured)
            pieces.remove(at: capturedIndex)
            SoundManager.shared.capture()
            isCapture = true
        } else {
            SoundManager.shared.moveSelf()
        }

        let movedPiece = ChessPiece(type: selected.type, color: selected.color, row: row, col: col, hasMoved: true)
        pieces.append(movedPiece)

        EnPassantManager.shared.registerDoublePawnMove(piece: movedPiece, fromRow: oldRow, toRow: row)

        if selected.type == .king {
            performCastlingIfNeeded(king: selected, fromCol: oldCol, toCol: col, row: row)
        }

        // ⭐️ MOVE HISTORY (ƏN VACİB HİSSƏ)
        let notation = ChessNotationConverter.notation(
            piece: selected,
            fromRow: oldRow,
            fromCol: oldCol,
            toRow: row,
            toCol: col,
            capture: isCapture
        )

        if selected.color == .white {
            pendingWhiteMove = notation
        } else {
            moveHistory.append(MoveRecord(whiteMove: pendingWhiteMove, blackMove: notation))
            pendingWhiteMove = nil
        }

        currentTurn = currentTurn == .white ? .black : .white
        ChessClockManager.shared.switchTurn(to: currentTurn)

        if CheckValidator.isKingInCheck(color: .white, pieces: pieces) {
            kingInCheck = .white
            SoundManager.shared.check()
        } else if CheckValidator.isKingInCheck(color: .black, pieces: pieces) {
            kingInCheck = .black
            SoundManager.shared.check()
        } else {
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
        pieces.removeAll { $0.row == pawn.row && $0.col == pawn.col }
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
        moveHistory.removeAll()
        pendingWhiteMove = nil
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
