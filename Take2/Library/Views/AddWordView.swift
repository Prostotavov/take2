//
//  AddWordView.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import SwiftUI

struct AddWordView: View {
    
    @Binding var showAddWordView: Bool
    @State var word = WordModel(name: "", translate: "", analogy: "", hint: "")
    @ObservedObject var dictionaryViewModel: DictionaryViewModel
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
            VStack {
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
                                        showAddWordView = false
                                    }, label: {
                                        Text("Cancel")
                                    })
                                    Spacer()
                                    Button(action: {
                                        dictionaryViewModel.add(word)
                                        showAddWordView = false
                                        dictionaryViewModel.printContent()
                                    }, label: {
                                        Text("Save")
                                    })
                                    
                                }
                            }
                            .padding()
                        )
                }
            }
        }
    }
}

struct AddWordView_Previews: PreviewProvider {
    static var dict = DictionaryModel(name: "")
    static var dictionary = DictionaryViewModel(dictionaryModel: dict)
    static var previews: some View {
        AddWordView(showAddWordView: .constant(true), dictionaryViewModel: dictionary)
    }
}
