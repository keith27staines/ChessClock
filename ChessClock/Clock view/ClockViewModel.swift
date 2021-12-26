//
//  ClockViewModel.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation
import Combine

class ClockViewModel: ObservableObject {
    @Published var state: TimeControlState = .waiting(lastMove: 0)
    @Published var timeRemainingString: String = 0.0.formattedString
    
    var player: Player
    var timeRemaining: TimeInterval = 0
    var hasFlagged: Bool { state.hasFlagged }
    private let timeControls: [TimeControl]
    private var timer: AnyCancellable?
    private(set) var moves = [Move]()
    
    enum TimeControlState {
        case moving(currentMove: Int)
        case waiting(lastMove: Int)
        case flagged(onMove: Int)
        
        var canBeginMove: Bool {
            switch self {
            case .waiting(_): return true
            default: return false
            }
        }
        
        var hasFlagged: Bool {
            switch self {
            case .flagged(_): return true
            default: return false
            }
        }
        
        var canFlag: Bool {
            canEndMove
        }
        
        var canEndMove: Bool {
            switch self {
            case .moving(_): return true
            default: return false
            }
        }
    }
    
    init(player: Player, timeControls: [TimeControl]) {
        self.player = player
        self.timeControls = timeControls
        guard let firstControl = timeControls.first else { return }
        setTimeRemainingFields(firstControl.timeInterval)
    }
    
    func beginMove() {
        guard state.canBeginMove else { return }
        let now = Date()
        let newMove = Move(number: currentMoveNumber, startedAt: now)
        moves.append(newMove)
        state = .moving(currentMove: newMove.number)
        startNewTimer()
    }
    
    func endMove() {
        guard state.canEndMove else { return }
        moves[currentMoveNumber - 1].completedAt = Date()
        state = .waiting(lastMove: currentMoveNumber)
    }
    
    private func startNewTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 0.1, tolerance: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] date in
                self?.onClockTick(date: date)
            })
    }
    
    private func onClockTick(date: Date) {
        guard case TimeControlState.moving(let moveNumber) = state else {
            timer?.cancel()
            return
        }
        let timeRemaining = max(timeRemainingBeforeFlag(now: date), 0.0)
        if timeRemaining == 0 && state.canFlag {
            state = .flagged(onMove: moveNumber)
        }
        setTimeRemainingFields(timeRemaining)
    }
    
    func setTimeRemainingFields(_ timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
        if timeRemaining > 10 {
            timeRemainingString = timeRemaining.formattedString
        } else {
            timeRemainingString = timeRemaining.formattedStringWithTenths
        }
    }

    private func timeRemainingBeforeFlag(now: Date) -> TimeInterval {
        var timeCarriedForward: TimeInterval = 0
        for tc in timeControls.completedOrInProgress(currentMoveNumber) {
            if tc == currentTimeControl {
                return timeCarriedForward + tc.timeInterval - moves.timeSpentInTimeControl(tc)
            } else {
                // completed time control
                timeCarriedForward +=  tc.timeInterval - moves.timeSpentInTimeControl(tc)
            }
        }
        return timeCarriedForward
    }
    
    var currentTimeControl: TimeControl {
        timeControls.timeControlForMove(currentMoveNumber)
    }
    
    var currentMoveNumber: Int {
        switch state {
        case .moving(currentMove: let currentMove):
            return currentMove
        case .waiting(lastMove: let lastMove):
            return lastMove + 1
        case .flagged(onMove: let onMove):
            return onMove
        }
    }
}

struct Move {
    let number: Int
    let startedAt: Date
    var completedAt: Date?
    var didFlag: Bool = false
    
    init(number: Int, startedAt: Date) {
        self.number = number
        self.startedAt = startedAt
    }
        
}
