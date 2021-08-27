//
//  Library.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

struct LibraryModel {
    
    // MARK: Future Feaches
    // В будущем будет несколько библиотек, между которыми можно будет переключатся
    
    private(set) var dictionaries: Array<DictionaryModel>
    
    // MARK: Bad Practice
    // нужно удалить ненужные функции и переименовать оставшиеся
    
    init() {
        self.dictionaries = Array<DictionaryModel>()
    }
    
    mutating func addDictionaries(dictionaries: [DictionaryModel]) {
        for dict in dictionaries {
            self.dictionaries.append(dict)
        }
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

