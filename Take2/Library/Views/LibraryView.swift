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
                        // MARK: Bad practice
                        // нужно сделать отдельную функцию, чтоб убрать логику
                        // нужно сделать еще один инициализатор для словаря 'DictionaryModel()'
                        let oldIndex: Int = indices.min() ?? 0 - 1 // тк в IndexSet индексация начинается с 1
                        let newIndex: Int = newOffset - 1
                        let dictionary = libraryViewModel.findDictionaryByUsersOrder(usersOrder: oldIndex) ?? DictionaryModel(name: "")
                        
                        libraryViewModel.move(oldIndex: oldIndex, newIndex: newIndex, dictionary: dictionary)
                    })
                }
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
