//
//  DictionaryView.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import SwiftUI

struct DictionaryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showAddWordView = false
    @State var showEditWordView = false
    @ObservedObject var dictionaryViewModel: DictionaryViewModel
    @State var index: Int = 0
    
    init(dictionary: DictionaryModel) {
        self.dictionaryViewModel = DictionaryViewModel(dictionaryModel: dictionary)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(dictionaryViewModel.words) { word in
                        Button(action: {
                            showEditWordView = true
                            index = dictionaryViewModel.choose(word: word)
                        }) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text(word.name).font(.headline)
                                    Text(word.translate)
                                }
                                Spacer()
                                Text(word.hint)
                            }

                        }
                    }
                    .onDelete(perform: { indexSet in
                        dictionaryViewModel.delete(at: indexSet)
                    })
                    .onMove(perform: { indices, newOffset in
                        dictionaryViewModel.moveWord(indices: indices, newOffset: newOffset)
                    })
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Dictionary")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddWordView = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack{
                                Image(systemName: "chevron.left")
                                    .font(.custom("", fixedSize: 24))
                                    .offset(x: 5)
                                Text("Back")
                            }
                            .offset(x: -11)
                        }
                    }
                }
            }
            .blur(radius: showAddWordView || showEditWordView ? 3.0 : 0)
            .navigationBarHidden(true)
            if showAddWordView {
                AddWordView(showAddWordView: $showAddWordView, dictionaryViewModel: dictionaryViewModel)
            }
            if showEditWordView {
                EditWordView(showEditWordView: $showEditWordView, dictionaryViewModel: dictionaryViewModel, index: index)
            }
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var dict = DictionaryModel(name: "")
    static var previews: some View {
        DictionaryView(dictionary: dict)
    }
}
