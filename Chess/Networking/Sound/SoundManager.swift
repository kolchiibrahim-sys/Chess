//
//  SoundManager.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import AudioToolbox

enum SoundManager {

    static func playCheckSound() {
        AudioServicesPlaySystemSound(1016) // short alert
    }

    static func playMoveSound() {
        AudioServicesPlaySystemSound(1104) // subtle tap
    }

    static func playCheckmateSound() {
        AudioServicesPlaySystemSound(1025) // success
    }
}
