//
//  ClockView.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import SwiftUI

struct ClockView: View {
    
    @ObservedObject var vm: ClockViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(vm.player.pieceColor.description)
                .font(.body)
                .fontWeight(.bold)
            Text(vm.player.name)
                .font(.headline)
            Text(vm.timeRemainingString)
                .font(.system(size: 20, weight: .heavy, design: .monospaced))
        }
        
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ClockViewModel(
            player: Player(name: "Player 1", pieceColor: .white),
            timeControls: [
                TimeControl(firstMove: 1, lastMove: 10, increment: 0, timeInterval: 20.0)
            ]
        )
        ClockView(vm: vm)
    }
}
