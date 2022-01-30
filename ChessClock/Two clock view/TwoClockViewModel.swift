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
            TimeControl(firstMoveNumber: 1, lastMoveNumber: 10, interval: 20.0, increment: 0)
        ]
    )
    
    enum State {
        case waiting
        case playing
        case flagged
        case ended
    }
    
    @Published var state: State = .waiting
    
    var hasFlagged: Bool {
        switch state {
        case .flagged: return true
        default: return false
        }
    }
    
    var players: [Player]
    var timeControls: [TimeControl]
    var clockModels: [ClockViewModel] = []
    var activePlayerIndex: Int
    var subscriptions = Set<AnyCancellable>()
    
    var inactivePlayerIndex: Int {
        activePlayerIndex == 0 ? 1 : 0
    }
    
    var timerButtonText: String {
        switch state {
        case .waiting:
            return "Start Game"
        case .playing:
            return "End Move"
        case .flagged:
            return "Play Again"
        case .ended:
            return "Play Again"
        }
    }
    
    var isTimerButtonDisabled: Bool {
        false
    }
    
    func onDidTaptimer() {
        switch state {
        case .waiting:
            startGame()
        case .playing:
            switchMove()
        case .flagged:
            newGame()
            startGame()
        case .ended:
            newGame()
            startGame()
        }
    }
    
    var isEndGameButtonDisabled: Bool {
        switch state {
        case .waiting:
            return false
        case .playing:
            return false
        case .flagged:
            return true
        case .ended:
            return true
        }
    }
    
    func onDidTapEndGame() {
        endGame()
    }
    
    private func startGame() {
        let clock = clockModels[activePlayerIndex]
        clock.beginMove()
        state = .playing
    }
    
    private func switchMove() {
        toggleActivePlayerIndex()
        let activatingClock = clockModels[activePlayerIndex]
        let deactivatingClock = clockModels[inactivePlayerIndex]
        deactivatingClock.endMove()
        activatingClock.beginMove()
        state = .playing
    }
    
    private func endGame() {
        stopClocks()
        state = .ended
    }
    
    private func newGame() {
        rebuildClocks()
        activePlayerIndex = 0
        state = .waiting
    }
    
    private func rebuildClocks() {
        stopClocks()
        createClocks()
    }
    
    private func stopClocks() {
        clockModels.forEach { clock in
            clock.stop()
        }
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    private func createClocks() {
        let clock1 = ClockViewModel(player: players[0], timeControls: timeControls)
        let clock2 = ClockViewModel(player: players[1], timeControls: timeControls)
        clockModels = [clock1, clock2]
        let clockStates = clock1.$state
            .combineLatest(clock2.$state)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] (state1, state2) in
                if state1.hasFlagged || state2.hasFlagged {
                    self?.state = .flagged
                }
                
            }
        subscriptions.insert(clockStates)
    }
    
    private func toggleActivePlayerIndex() {
        activePlayerIndex = (activePlayerIndex == 0) ? 1 : 0
    }
    
    init(timeControls: [TimeControl]) {
        self.timeControls = timeControls
        self.players = [
            Player(name: "Player 1", pieceColor: .white),
            Player(name: "Player 2", pieceColor: .black)
        ]
        activePlayerIndex = 0
        newGame()
    }
    
}

