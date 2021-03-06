//
//  LibraryView.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import SwiftUI

struct LibraryView: View {
    
    @ObservedObject var libraryViewModel: LibraryViewModel
    @State var showAddDictView = false
    
    var body: some View {
        ZStack{
            NavigationView {
                List {
                    ForEach(libraryViewModel.dictionaries) {dict in
                            NavigationLink(
                                destination: DictionaryView(dictionary: libraryViewModel.choose(dict: dict))
                            ) {
                                Text(dict.name)
                            }
                    }
                    .onDelete(perform: { indexSet in
                        libraryViewModel.delete(at: indexSet)
                    })
                    .onMove(perform: { indices, newOffset in
                        libraryViewModel.moveDictionary(fromOffsets: indices, toOffset: newOffset)
                        libraryViewModel.updateIndices(fromOffsets: indices, toOffset: newOffset, dictionaries: libraryViewModel.dictionaries)
                    })
                }
                .listStyle(InsetGroupedListStyle())
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Library")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddDictView = true
                        }){
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                }
            }
            .blur(radius: showAddDictView ? 3.0 : 0)
            if showAddDictView {
                AddDictionaryView(showAddDictView: $showAddDictView, libraryViewModel: libraryViewModel)
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static let library = LibraryViewModel()
    static var previews: some View {
        Group {
            LibraryView(libraryViewModel: library)
        }
    }
}
