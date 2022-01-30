//
//  Library.swift
//  ChessClock
//
//  Created by Keith Staines on 30/01/2022.
//

import Foundation

class LibraryViewModel: ObservableObject {
    
    var library: Library
    
    init() {
        library = Bundle.main.decode(Library.self, from: "Library.json")
    }
    
}
