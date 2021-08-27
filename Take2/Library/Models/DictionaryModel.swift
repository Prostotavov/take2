//
//  Dictionary.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DictionaryModel: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    var name: String
    
    private(set) var words: Array<WordModel>
    
    init(name: String) {
        self.name = name
        self.words = Array<WordModel>()
        print("DM init name")
    }
    
    func addWord(word: WordModel) {
        self.words.append(WordModel(name: word.name, translate: word.translate, analogy: word.analogy, hint: word.hint))
    }
    
    func addWords(words: [WordModel]) {
        for word in words {
            self.words.append(word)
        }
    }
    
    func deleteWord(at indexSet: IndexSet) {
        words.remove(atOffsets: indexSet)
    }
    
    func deleleAllWords() {
        words = []
    }
    
    func editWord(index: Int, newWord: WordModel) {
        self.words[index] = newWord
    }
    
    func choose(word: WordModel) -> Int {
        let index = words.firstIndex(where: { $0.id == word.id }) ?? 0
        return index
    }
    
    func moveWord(indices: IndexSet, newOffset: Int) {
        words.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    // MARK: functions for debug
    
    func printContent () {
        words.forEach { print($0.name) }
    }
    
    func getID() -> String? {
        return self.id
    }
    
    func isEmpty() {
        if !self.words.isEmpty {
            self.printContent()
        }
        else {
            print("Array of words is empty")
        }
    }
    
}
