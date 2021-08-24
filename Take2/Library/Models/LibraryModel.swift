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
        for index in indexSet {
            dictionaries.remove(at: index)
        }
    }
    
    func choose(dict: Dictionary) -> Dictionary {
        let index = dictionaries.firstIndex(where: { $0.id == dict.id }) ?? 0
        return self.dictionaries[index]
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

