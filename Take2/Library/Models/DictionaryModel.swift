//
//  Dictionary.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

struct Dictionary: Identifiable {
    
    var id = UUID()
    var name: String
    private(set) var words: Array<Word>
    
    mutating func addWord(word: Word) {
        self.words.append(Word(name: word.name, translate: word.translate, analogy: word.analogy, hint: word.hint))
    }
    
    mutating func editWord(index: Int, newWord: Word) {
        self.words[index] = newWord
    }
    
    func choose(word: Word) -> Int {
        let index = words.firstIndex(where: { $0.id == word.id }) ?? 0
        return index
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