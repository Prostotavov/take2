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
    
    func choose(dict: Dictionary) -> Dictionary {
        libraryModel.choose(dict: dict)
    }    
    
    // MARK: functions for debug
    
    func printContent () {
        libraryModel.printContent()
    }
    
}


