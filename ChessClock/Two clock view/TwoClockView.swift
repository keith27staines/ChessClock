//
//  TwoClockView.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import SwiftUI

struct TwoClockView: View {
    
    @ObservedObject var vm: TwoClockViewModel
    @State var playerRotationScale: CGFloat = 0
    @Namespace private var animation
    
    var body: some View {
        VStack {
            topButtonsStack
                .padding()
            Spacer()
            twoClocksStack
                .frame(maxWidth: .infinity)
                .padding(.bottom)
            Spacer()
            timerButton
        }
        .padding()
        
    }
    
    var topButtonsStack: some View {
        HStack {
            Spacer()
            endGameButton
            Spacer()
            settingsButton
            Spacer()
        }
    }
    
    var twoClocksStack: some View {
        GeometryReader { geo in
            let clockWidth: CGFloat = geo.size.width / 2
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    if playerRotationScale == 0 {
                        ClockView(vm: vm.clockModels[0])
                            .frame(maxWidth: clockWidth)
                            .matchedGeometryEffect(id: "clock0", in: animation)
                        switchPlayerPositionsButton
                            .matchedGeometryEffect(id: "button", in: animation)
                        ClockView(vm: vm.clockModels[1])
                            .frame(maxWidth: clockWidth)
                            .matchedGeometryEffect(id: "clock1", in: animation)
                    } else {
                        ClockView(vm: vm.clockModels[1])
                            .frame(maxWidth: clockWidth)
                            .matchedGeometryEffect(id: "clock1", in: animation)
                        switchPlayerPositionsButton
                            .matchedGeometryEffect(id: "button", in: animation)
                        ClockView(vm: vm.clockModels[0])
                            .frame(maxWidth: clockWidth)
                            .matchedGeometryEffect(id: "clock0", in: animation)
                    }
                }
                Spacer()
            }
            
        }
    }
    
    var switchPlayerPositionsButton: some View {
        Button(action: {
            withAnimation {
                playerRotationScale = playerRotationScale == 0 ? 1 : 0
            }
        }) {
            Image(systemName: "arrow.triangle.capsulepath")
                .font(.title)
                .foregroundColor(.primary)
                .rotation3DEffect(
                    Angle(degrees: playerRotationScale * 180),
                    axis: (x: 1, y: 0, z: 0),
                    anchor: UnitPoint(x: 0.5, y: 0.5),
                    anchorZ: 0,
                    perspective: 0)
                .rotationEffect(Angle(degrees: 90))
        }
    }
    
    var endGameButton: some View {
        Button(action: vm.onDidTapEndGame) {
            HStack {
                Image(systemName: "stop.circle")
                Text("End game")
            }
        }
        .buttonStyle(ChessButtonStyle(buttonType: .primary, disabled: vm.isEndGameButtonDisabled))
        .disabled(vm.isEndGameButtonDisabled)
    }
    
    var settingsButton: some View {
        Button(action: {
            
        }) {
            HStack {
                Image(systemName: "gearshape.2")
                Text("Settings")
            }
        }
        .buttonStyle(ChessButtonStyle(buttonType: .primary))
    }

    var timerButton: some View {
        Button(action: vm.onDidTaptimer) {
            Text(vm.timerButtonText)
                .font(.largeTitle)
        }
        .buttonStyle(ChessEndMoveButtonStyle(disabled: vm.isTimerButtonDisabled))
        .disabled(vm.isTimerButtonDisabled)
    }
}

struct TwoClockView_Previews: PreviewProvider {
    static var previews: some View {
        TwoClockView(vm: TwoClockViewModel.testModel)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
