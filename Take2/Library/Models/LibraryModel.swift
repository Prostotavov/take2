//
//  Library.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

struct Library {
    
    private(set) var dictionaries: Array<Dictionary>
    
    mutating func addDictionary(dictionary: Dictionary) {
        self.dictionaries.append(dictionary)
    }
    
    mutating func deleteDictionary(at indexSet: IndexSet) {
            dictionaries.remove(atOffsets: indexSet)
    }
    
    func choose(dict: Dictionary) -> Dictionary {
        let index = dictionaries.firstIndex(where: { $0.id == dict.id }) ?? 0
        return self.dictionaries[index]
    }
    
    mutating func moveDictionary(indices: IndexSet, newOffset: Int) {
        dictionaries.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    init() {
        self.dictionaries = Array<Dictionary>()
    }
    
    // MARK: functions for debug
    
    func printContent () {
        dictionaries.forEach { print($0.name) }
    }
    
    func isEmpty() {
        if !self.dictionaries.isEmpty {
            self.printContent()
        }
        else {
            print("Array of dicts is empty")
        }
    }
    
}

