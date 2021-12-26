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
                TimeControl(firstMove: 1, lastMove: 10, increment: 0, timeInterval: 20.0)
            ]
            let vm = TwoClockViewModel(timeControls: timeControls)
            TwoClockView(vm: vm)
        }
    }
}
