//
//  TimeControlDefinition.swift
//  ChessClock
//
//  Created by Keith Staines on 29/01/2022.
//

import Foundation

/// A store of GameTimeControlDefinitions
struct Library: Codable {
    var gameDefinitions: [GameDefinition]
    func filterByType(_ type: GameCategory) -> [GameDefinition] {
        gameDefinitions.filter { definition in
            definition.category == type
        }
    }
}

/// The types of time control
enum GameCategory: String, Codable {
    case hyperBullet = "hyper-bullet"
    case bullet
    case blitz
    case rapid
    case classical
    case custom
}


/// The list of time control definitions for all moves in a game
struct GameDefinition: Codable, Hashable, Identifiable {
    var id: Int
    var category: GameCategory
    var controls: [TimeControlDefinition]
    var customName: String?
    
    var name: String {
        category.rawValue
    }
    
    func description(for control: TimeControlDefinition) -> String {
        guard controls.count > 0 else { return "" }
        let moves = control.numberOfMoves
        var movesString: String = ""
        if controls.count == 1 {
            movesString  = "All moves"
        } else {
            if control != controls.last {
                movesString = "\(moves) moves"
            }
        }
        return "\(movesString): \(control.description)"
    }
}

/// The definition of a time control for a prescribed number of moves
struct TimeControlDefinition: Codable, Hashable, Identifiable {
    var id: Int
    var numberOfMoves: Int
    var interval: TimeInterval
    var increment: TimeInterval
    
    var description: String {
        switch interval {
        case let minutes where minutes < 60:
            return "\(Int(interval))s + \(Int(increment))s"
        default:
            return "\(Int(interval/60))m + \(Int(increment))s"
        }
    }
}
