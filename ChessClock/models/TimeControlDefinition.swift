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
struct GameDefinition: Codable, Identifiable {
    var id: Int
    var category: GameCategory
    var controls: [TimeControlDefinition]
    var customName: String?
    
    var name: String {
        category.rawValue
    }
}

/// The definition of a time control for a prescribed number of moves
struct TimeControlDefinition: Codable {
    var numberOfMoves: Int
    var interval: TimeInterval
    var increment: TimeInterval
    
    var description: String {
        "\(interval*60) + \(increment)"
    }
}
