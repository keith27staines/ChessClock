//
//  TwoClockViewModel.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation
import Combine

class TwoClockViewModel: ObservableObject {
    
    static let testModel = TwoClockViewModel(
        timeControls: [
            TimeControl(firstMove: 1, lastMove: 10, increment: 0, timeInterval: 20.0)
        ]
    )
    
    var clockModels: [ClockViewModel]
    var activePlayerIndex: Int?
    var inactivePlayerIndex: Int? {
        if activePlayerIndex == nil { return nil }
        return activePlayerIndex == 0 ? 1 : 0
    }
    
    var isTimerButtonDisabled: Bool {
        hasFlagged
    }
    
    var hasFlagged: Bool {
        clockModels.reduce(false) { hasFlagged, clock in
            hasFlagged || clock.hasFlagged
        }
    }
    
    func onDidTaptimerButton() {
        toggleActivePlayerIndex()
        guard
            let activePlayerIndex = activePlayerIndex,
            let inactivePlayerIndex = inactivePlayerIndex
        else { return }
 
        let activatingClock = clockModels[activePlayerIndex]
        let deactivatingClock = clockModels[inactivePlayerIndex]
        deactivatingClock.endMove()
        activatingClock.beginMove()
    }
    
    private func toggleActivePlayerIndex() {
        if activePlayerIndex == nil {
            activePlayerIndex = 0
        } else {
            activePlayerIndex = (activePlayerIndex == 0) ? 1 : 0
        }
    }
    
    init(timeControls: [TimeControl]) {
        let players = [
            Player(name: "Player 1", pieceColor: .white),
            Player(name: "Player 2", pieceColor: .black)
        ]

        clockModels = [
            ClockViewModel(player: players[0], timeControls: timeControls),
            ClockViewModel(player: players[1], timeControls: timeControls)
        ]
    }
    
}

