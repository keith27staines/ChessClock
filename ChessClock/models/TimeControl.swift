//
//  TimeControl.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation

struct TimeControl: Hashable {
    let firstMoveNumber: Int
    let lastMoveNumber: Int
    let interval: TimeInterval
    let increment: TimeInterval
    var moveRange: ClosedRange<Int> { (firstMoveNumber...lastMoveNumber) }
}

extension Array where Element == TimeControl {
    func timeControlForMove(_ move: Int) -> TimeControl {
        first { timeControl in
            (timeControl.firstMoveNumber...timeControl.lastMoveNumber).contains(move)
        } ?? TimeControl(firstMoveNumber: move, lastMoveNumber: Int.max, interval: 0, increment: 0)
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
        return String(
            "\(intHours.formatted02d) : \(intMinutes.formatted02d) : \(intSeconds.formatted02d)"
        )
    }
    
    var formattedStringWithTenths: String {
        let intTenths = Int((self - Double(Int(self)))*100)
        return formattedString + " : \(intTenths.formatted02d)"
    }
}

extension Int {
    var formatted02d: String {
        String(format: "%02d", self)
    }
    
}
