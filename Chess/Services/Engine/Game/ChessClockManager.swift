//
//  ChessClockManager.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//

import Foundation
import Foundation

final class ChessClockManager {

    static let shared = ChessClockManager()
    private init() {}

    private var timer: Timer?

    private(set) var whiteTime: Int = 600   // 10 
    private(set) var blackTime: Int = 600

    private var currentTurn: PieceColor = .white

    var onTick: (() -> Void)?
    var onTimeOver: ((PieceColor) -> Void)?

    func start(turn: PieceColor) {
        currentTurn = turn
        startTimer()
    }

    func switchTurn(to turn: PieceColor) {
        currentTurn = turn
    }

    func reset() {
        timer?.invalidate()
        whiteTime = 600
        blackTime = 600
        onTick?()
    }

    private func startTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }

    private func tick() {

        if currentTurn == .white {
            whiteTime -= 1
            if whiteTime <= 0 {
                timer?.invalidate()
                onTimeOver?(.white)
            }
        } else {
            blackTime -= 1
            if blackTime <= 0 {
                timer?.invalidate()
                onTimeOver?(.black)
            }
        }

        onTick?()
    }

    func formattedWhiteTime() -> String { format(whiteTime) }
    func formattedBlackTime() -> String { format(blackTime) }

    private func format(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
