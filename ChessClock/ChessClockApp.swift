//
//  ChessClockApp.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import SwiftUI

@main
struct ChessClockApp: App {
    var body: some Scene {
        WindowGroup {
            let timeControls = [
                TimeControl(firstMoveNumber: 1, lastMoveNumber: 10, interval: 20.0, increment: 0)
            ]
            let vm = TwoClockViewModel(timeControls: timeControls)
            TwoClockView(vm: vm)
        }
    }
}
