//
//  LibraryView.swift
//  ChessClock
//
//  Created by Keith Staines on 29/01/2022.
//

import SwiftUI

struct LibraryView: View {
    
    @ObservedObject private var vm: LibraryViewModel

    var body: some View {
        List(vm.gameDefinitions, selection: $vm.selectedGameDefinition) { gameDefinition in
            Button {
                vm.selectedGameDefinition = gameDefinition
            } label: {
                HStack {
                    GameDefinitionView(gameDefinition)
                    Spacer()
                    if gameDefinition == vm.selectedGameDefinition {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem {
                Button {
                    // show TC editor
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
    }
    
    init(vm: LibraryViewModel) {
        self.vm = vm
    }
}

struct GameDefinitionView: View {
    
    private var gameDefinition: GameDefinition
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(gameDefinition.category.rawValue)
            ForEach(gameDefinition.controls) { control in
                Text(control.description)
                    .font(.caption)
            }
        }
    }
    
    init(_ gameDefinition: GameDefinition) {
        self.gameDefinition = gameDefinition
    }

}

struct LibraryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = LibraryViewModel()
        LibraryView(vm: vm)
    }
}
