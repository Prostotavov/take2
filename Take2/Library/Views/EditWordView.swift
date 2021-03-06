//
//  EditWordView.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import SwiftUI

struct EditWordView: View {
    
    @Binding var showEditWordView: Bool
    @State var word = WordModel()
    @ObservedObject var dictionaryViewModel: DictionaryViewModel
    var index: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill (Color(.systemBackground))
                .shadow(radius: 10)
                .frame(width: 300, height: 240)
                .overlay(
                    VStack(alignment: .leading) {
                        
                        TextField("word", text: $word.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("translate", text: $word.translate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("analogy", text: $word.analogy)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("hint", text: $word.hint)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                showEditWordView = false
                            }, label: {
                                Text("Cancel")
                            })
                            Spacer()
                            Button(action: {
                                dictionaryViewModel.update(word)
                                showEditWordView = false
                            }, label: {
                                Text("Save")
                            })
                        }
                    }
                    .padding()
                )
        }
        .ignoresSafeArea()
        .onAppear() {
            word = dictionaryViewModel.words[index]
        }
    }
}



struct EditWordView_Previews: PreviewProvider {
    
    static var dictionary = DictionaryViewModel(dictionaryModel: DictionaryModel())
    static var word = WordModel()
    static var index: Int = -2
    
    static var previews: some View {
        EditWordView(showEditWordView: .constant(true), dictionaryViewModel: dictionary, index: index)
    }
}
