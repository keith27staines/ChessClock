//
//  TwoClockViewModel.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation
import Combine

class TwoClockViewModel: ObservableObject {
    
    @Published var hasFlagged: Bool = false
    
    static let testModel = TwoClockViewModel(
        timeControls: [
            TimeControl(firstMove: 1, lastMove: 10, increment: 0, timeInterval: 20.0)
        ]
    )
    var subscriptions = Set<AnyCancellable>()
    var clockModels: [ClockViewModel]
    var activePlayerIndex: Int?
    var inactivePlayerIndex: Int? {
        if activePlayerIndex == nil { return nil }
        return activePlayerIndex == 0 ? 1 : 0
    }
    
    var isTimerButtonDisabled: Bool {
        hasFlagged
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
        let clock1 = ClockViewModel(player: players[0], timeControls: timeControls)
        let clock2 = ClockViewModel(player: players[1], timeControls: timeControls)
        
        clockModels = [clock1, clock2]
        
        
        let clockStates = clock1.$state
            .combineLatest(clock2.$state)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] (state1, state2) in
                self?.hasFlagged = state1.hasFlagged || state2.hasFlagged
            }
        subscriptions.insert(clockStates)
    }
    
}

