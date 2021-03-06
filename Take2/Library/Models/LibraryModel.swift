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
    
    func findDictionaryIn(_ indices: IndexSet) -> DictionaryModel {
        for dict in dictionaries {
            if dict.index == indices.min() ?? 0 {
                return dict
            }
        }
        return DictionaryModel()
    }
    
    mutating func moveDictionary(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        
        let oldIndex: Int = indices.min() ?? 0
        var newIndex: Int = newOffset
        if oldIndex < newIndex { newIndex -= 1 }
        // так как если oldIndex < newIndex, то newIndex почему то становится больше на 1
        dictionaries[oldIndex].index = newIndex
        
        var i = -1
        for dictionary in dictionaries {
            i += 1
            if oldIndex < newIndex {
                if (oldIndex...newIndex).contains(dictionary.index) && dictionary.id != dictionaries[oldIndex].id {
                    dictionaries[i].index -= 1
                }
            } else {
                if (newIndex...oldIndex).contains(dictionary.index) && dictionary.id != dictionaries[oldIndex].id {
                    dictionaries[i].index += 1
                }
            }
        }
        dictionaries.move(fromOffsets: indices, toOffset: newOffset)
    }
    
}



