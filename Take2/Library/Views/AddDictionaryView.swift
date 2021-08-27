//
//  AddDictionaryView.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import SwiftUI

struct AddDictionaryView: View {
    
    @Binding var showAddDictView: Bool
    @State var dict = DictionaryModel(name: "")
    @ObservedObject var libraryViewModel: LibraryViewModel
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
            VStack {
                ZStack {
                    Button(action: {
                        showAddDictView = false
                    }){
                        Rectangle()
                            .fill(Color.init(.clear))
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill (Color(.systemBackground))
                        .shadow(radius: 10)
                        .frame(width: 300, height: 120)
                        .overlay(
                            VStack(alignment: .leading) {
                    
                                TextField("name", text: $dict.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        showAddDictView = false
                                    }, label: {
                                        Text("Cancel")
                                    })
                                    Spacer()
                                    Button(action: {
                                        libraryViewModel.add(dict)
                                        showAddDictView = false
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
        .ignoresSafeArea()
    }
}

struct AddDictionaryView_Previews: PreviewProvider {
    static let library = LibraryViewModel()
    static var previews: some View {
        AddDictionaryView(showAddDictView: .constant(true), libraryViewModel: library)
    }
}
