//
//  Dictionary.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct DictionaryModel: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    @ServerTimestamp var createdTime: Timestamp?
    // MARK: super bad practice
    // нужно сделать либо обратный отсчет индексов, либо сделать ограничение на словарь
    // по словам, максимум 100000 словарей в библиотеке
    var index = 100000
    
    // MARK: Future Feaches
    // В будущем можно будет изменять название словаря
    var name: String
    
    private(set) var words: Array<WordModel>
    
    init(name: String) {
        self.name = name
        self.words = Array<WordModel>()
    }
    
    init() {
        self.name = ""
        self.words = Array<WordModel>()
    }
    
    mutating func addWords(words: [WordModel]) {
        for word in words {
            self.words.append(word)
        }
    }
    
    mutating func deleleAllWords() {
        words = []
    }

    func choose(word: WordModel) -> Int {
        let index = words.firstIndex(where: { $0.id == word.id }) ?? 0
        return index
    }
    
    func findWordIn(_ indices: IndexSet) -> WordModel {
        for word in words {
            if word.index == indices.min() ?? 0 {
                return word
            }
        }
        return WordModel()
    }
    
    mutating func moveWord(fromOffsets indices: IndexSet, toOffset newOffset: Int) {
        let oldIndex: Int = indices.min() ?? 0
        var newIndex: Int = newOffset
        if oldIndex < newIndex { newIndex -= 1 }
        // так как если oldIndex < newIndex, то newIndex почему то становится больше на 1
        words[oldIndex].index = newIndex
        var i = -1
        for word in words {
            i += 1
            if oldIndex < newIndex {
                if (oldIndex...newIndex).contains(word.index) && word.id != words[oldIndex].id {
                    words[i].index -= 1
                }
            } else {
                if (newIndex...oldIndex).contains(word.index) && word.id != words[oldIndex].id {
                    words[i].index += 1
                }
            }
        }
        words.move(fromOffsets: indices, toOffset: newOffset)
    }
    
}
