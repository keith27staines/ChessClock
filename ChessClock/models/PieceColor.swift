//
//  PieceColor.swift
//  ChessClock
//
//  Created by Keith Staines on 25/12/2021.
//

import Foundation


enum PieceColor {
    case white
    case black
    
    var description: String {
        switch self {
        case .white: return "White"
        case .black: return "Black"
        }
    }
}
