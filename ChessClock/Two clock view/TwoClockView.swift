//
//  TwoClockView.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import SwiftUI

struct TwoClockView: View {
    
    @ObservedObject var vm: TwoClockViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ClockView(vm: vm.clockModels[0])
                Spacer()
                ClockView(vm: vm.clockModels[1])
                Spacer()
            }
            timerButton
        }
    }

    var timerButton: some View {
        Button("Button text") {
            vm.onDidTaptimerButton()
        }
        .disabled(vm.isTimerButtonDisabled)
        .foregroundColor(.white)
        .padding()
        .padding()
        .frame(maxWidth: .infinity)
        
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.green)
        )
        .padding(.horizontal)
        

    }
}

struct TwoClockView_Previews: PreviewProvider {
    static var previews: some View {
        TwoClockView(vm: TwoClockViewModel.testModel)
    }
}
