//
//  ButtonStyles.swift
//  ChessClock
//
//  Created by Keith Staines on 27/12/2021.
//

import SwiftUI

struct ButtonStyles: View {
    var body: some View {
        VStack(spacing: 16) {
            Button("End move") {}
            .buttonStyle(ChessEndMoveButtonStyle(disabled:false))
            Button("Primary") {}
            .buttonStyle(ChessButtonStyle(buttonType: .primary, disabled: true))
            .disabled(false)
            Button("Secondary") {}
            .buttonStyle(ChessButtonStyle(buttonType: .secondary))
            Button("Tertiary") {}
            .buttonStyle(ChessButtonStyle(buttonType: .tertiary))
        }
        .padding()
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyles()
            .preferredColorScheme(.light)
    }
}

struct ChessEndMoveButtonStyle: ButtonStyle {
    
    let disabled: Bool
     
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.green)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
                        .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ChessButtonStyle: ButtonStyle {

    let buttonType: ChessButtonStyleType
    let disabled: Bool
    
    init(buttonType: ChessButtonStyleType, disabled: Bool = false) {
        self.buttonType = buttonType
        self.disabled = disabled
    }
 
    func makeBody(configuration: Self.Configuration) -> some View {
        let foregroundColor = disabled ? Color("DisabledForegroundColor") :  buttonType.foregroundColor
        let backgroundColor = disabled ? Color("DisabledBackgroundColor") : buttonType.backgroundColor
        let shadowColor = Color.primary.opacity(0.4)
        configuration.label
            .foregroundColor(foregroundColor)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(backgroundColor)
                        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
                )
                
                .scaleEffect(configuration.isPressed ? 0.9 : 1)
                            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

enum ChessButtonStyleType {
    case primary
    case secondary
    case tertiary
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .white
        case .tertiary:
            return .white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return .blue
        case .secondary:
            return .orange
        case .tertiary:
            return Color.mint
        }
    }
}
