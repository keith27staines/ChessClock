//
//  LibraryView.swift
//  ChessClock
//
//  Created by Keith Staines on 29/01/2022.
//

import SwiftUI

struct LibraryView: View {
    
    @State private var library = Bundle.main.decode(Library.self, from: "Library.json")

    var body: some View {
        List(library.gameDefinitions) { definition in
            Text(definition.category.rawValue)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
