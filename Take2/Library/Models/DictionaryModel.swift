//
//  Dictionary.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation
class Dictionary: Identifiable {
    
    var id = UUID()
    var name: String
    private(set) var words: Array<Word>
    
    func addWord(word: Word) {
        self.words.append(Word(name: word.name, translate: word.translate, analogy: word.analogy, hint: word.hint))
    }
    
    func deleteWord(at indexSet: IndexSet) {
        words.remove(atOffsets: indexSet)
    }
    
    func editWord(index: Int, newWord: Word) {
        self.words[index] = newWord
    }
    
    func choose(word: Word) -> Int {
        let index = words.firstIndex(where: { $0.id == word.id }) ?? 0
        return index
    }
    
    func moveWord(indices: IndexSet, newOffset: Int) {
        words.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    init(name: String) {
        self.name = name
        self.words = Array<Word>()
        print("DM init name")
    }
    
    // MARK: functions for debug
    
    func printContent () {
        words.forEach { print($0.name) }
    }
    
    func getID() -> UUID {
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
