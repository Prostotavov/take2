//
//  LibraryViewModel.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

class LibraryViewModel: ObservableObject {
    
    @Published private var libraryModel: Library = Library()
    
    var dictionaries: Array<Dictionary> {
        return libraryModel.dictionaries
    }
    
    func addDictionary(dictionary: Dictionary) {
        libraryModel.addDictionary(dictionary: dictionary)
    }
    
    func deleteDictionary(at indexSet: IndexSet) {
        libraryModel.deleteDictionary(at: indexSet)
    }
    
    func choose(dict: Dictionary) -> Dictionary {
        libraryModel.choose(dict: dict)
    }
    
    func moveDictionary(indices: IndexSet, newOffset: Int) {
        libraryModel.moveDictionary(indices: indices, newOffset: newOffset)
    }
    
    // MARK: functions for debug
    
    func printContent () {
        libraryModel.printContent()
    }
    
}


