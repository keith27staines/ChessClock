//
//  TwoClockViewModel.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation
import Combine
import SwiftUI

class TwoClockViewModel: ObservableObject {
    
    @Published var gameDefinition: GameDefinition?
    
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
    
    let libraryViewModel = LibraryViewModel()
    
    var selectTimeControlButtonText: String {
        gameDefinition == nil ? "Select time control" : "Change time control"
    }
    
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
    private var clockSubscriptions = Set<AnyCancellable>()
    private var gameDefinitionSubscription: AnyCancellable?
    
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
        gameDefinition == nil
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
        guard gameDefinition != nil else { return true }
        switch state {
        case .waiting:
            return true
        case .playing:
            return false
        case .flagged:
            return true
        case .ended:
            return true
        }
    }
    
    var isTimeControlButtonDisabled: Bool { !isEndGameButtonDisabled }
    
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
        regenerateTimeControls()
        rebuildClocks()
        activePlayerIndex = 0
        state = .waiting
    }
    
    private func regenerateTimeControls() {
        timeControls = []
        guard let gameDefinition = gameDefinition else { return }
        var firstMove = 1
        gameDefinition.controls.forEach { definition in
            let lastMove = definition.numberOfMoves - 1
            let control = TimeControl(
                firstMoveNumber: firstMove, lastMoveNumber: lastMove, interval: definition.interval, increment: definition.increment
            )
            timeControls.append(control)
            firstMove += definition.numberOfMoves
        }
    }
    
    private func rebuildClocks() {
        stopClocks()
        createClocks()
    }
    
    private func stopClocks() {
        clockModels.forEach { clock in
            clock.stop()
        }
        clockSubscriptions.forEach { $0.cancel() }
        clockSubscriptions.removeAll()
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
        clockSubscriptions.insert(clockStates)
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
        gameDefinitionSubscription = libraryViewModel.$selectedGameDefinition
            .sink { [weak self] gameDefinition in
                self?.gameDefinition = gameDefinition
                self?.newGame()
            }
    }
    
}

