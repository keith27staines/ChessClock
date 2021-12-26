//
//  TimeControl.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation

struct TimeControl: Hashable {
    let firstMove: Int
    let lastMove: Int
    let increment: Int
    let timeInterval: TimeInterval
    var moveRange: ClosedRange<Int> { (firstMove...lastMove) }
}

extension Array where Element == TimeControl {
    func timeControlForMove(_ move: Int) -> TimeControl {
        first { timeControl in
            (timeControl.firstMove...timeControl.lastMove).contains(move)
        } ?? TimeControl(firstMove: move, lastMove: Int.max, increment: 0, timeInterval: 0)
    }
    
    func completedOrInProgress(_ move: Int) -> [TimeControl] {
        filter { timeControl in
            timeControl.moveRange.contains(move)
        }
    }
}


extension Array where Element == Move {
    func movesUnderTimeControl(_ tc: TimeControl) -> [Move] {
        filter { move in
            tc.moveRange.contains(move.number)
        }
    }
    
    func timeSpentInTimeControl(_ tc: TimeControl) -> TimeInterval {
        movesUnderTimeControl(tc)
            .reduce(0.0) { timeSpent, move in
                if let completedAt = move.completedAt {
                    return timeSpent + completedAt.timeIntervalSince(move.startedAt)
                } else {
                    return timeSpent + Date().timeIntervalSince(move.startedAt)
                }
            }
    }
}

extension TimeInterval {
    var formattedString: String {
        let intHours = Int(self/3600)
        let intMinutes = Int((self - Double(intHours) * 3600.0)/60)
        let intSeconds = Int((self - Double(intHours) * 3600.0 - Double(intMinutes) * 60))
        return String("\(intHours):\(intMinutes):\(intSeconds)")
    }
    
    var formattedStringWithTenths: String {
        formattedString + ":\(Int((self - Double(Int(self)))*10))"
    }
}
