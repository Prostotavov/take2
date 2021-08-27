//
//  Library.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

struct LibraryModel {
    
    private(set) var dictionaries: Array<DictionaryModel>
    
    mutating func addDictionary(dictionary: DictionaryModel) {
        self.dictionaries.append(dictionary)
    }
    
    mutating func addDictionaries(dictionaries: [DictionaryModel]) {
        for dict in dictionaries {
            self.dictionaries.append(dict)
        }
    }
    
    mutating func deleteDictionary(at indexSet: IndexSet) {
            dictionaries.remove(atOffsets: indexSet)
    }
    
    mutating func deleleAllDictionaries() {
        dictionaries = []
    }
    
    func choose(dict: DictionaryModel) -> DictionaryModel {
        let index = dictionaries.firstIndex(where: { $0.id == dict.id }) ?? 0
        return self.dictionaries[index]
    }
    
    mutating func moveDictionary(indices: IndexSet, newOffset: Int) {
        dictionaries.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    init() {
        self.dictionaries = Array<DictionaryModel>()
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

