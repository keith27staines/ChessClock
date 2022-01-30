//
//  TimeControlManager.swift
//  ChessClock
//
//  Created by Keith Staines on 30/12/2021.
//

import Foundation
import Combine

class TimeControlManager: ObservableObject {
    
    private (set) var definitions = [TimeControlDefinition]() {
        didSet {
            timeControls = timeControlsFromDefinitions(definitions)
        }
    }
    
    @Published var timeControls: [TimeControl] = []
    
    init(_ definitions: [TimeControlDefinition] = []) {
        self.definitions = definitions
        timeControls = timeControlsFromDefinitions(definitions)
    }
    
    func appendDefinition(_ definition: TimeControlDefinition) {
        definitions.append(definition)
    }
    
    func insertDefinition(_ definition: TimeControlDefinition, at index: Int) {
        definitions.insert(definition, at: index)
    }
    
    func removeDefinition(at index: Int) {
        definitions.remove(at: index)
    }
    
    func timeControlsFromDefinitions(_ definitions: [TimeControlDefinition]) -> [TimeControl] {
        var last = 0
        return definitions.map { definition in
            let tc = TimeControl(
                firstMoveNumber: last + 1,
                lastMoveNumber: last + definition.numberOfMoves,
                interval: definition.interval,
                increment: definition.increment
            )
            last = last + definition.numberOfMoves
            return tc
        }
    }
}
