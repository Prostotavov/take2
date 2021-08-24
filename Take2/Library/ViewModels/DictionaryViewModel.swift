//
//  DictionaryViewModel.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

class DictionaryViewModel: ObservableObject {
        
    @Published private var dictionaryModel: Dictionary
    
    var words: Array<Word> {
        return dictionaryModel.words
    }
    
    func addWord(word: Word) {
        dictionaryModel.addWord(word: word)
    }
    
    func editWord(index: Int, newWord: Word) {
        dictionaryModel.editWord(index: index, newWord: newWord)
    }
    
    func choose(word: Word) -> Int {
        dictionaryModel.choose(word: word)
    }
    
    init(dictionaryModel: Dictionary) {
        self.dictionaryModel = dictionaryModel
        
        print(dictionaryModel.name)
        print("DVM init for \(self.dictionaryModel.getID())")
        dictionaryModel.printContent()
    }
    
    // MARK: functions for debug
    
    func printContent () {
        dictionaryModel.printContent()
    }
    
    func getID() -> UUID {
        return dictionaryModel.getID()
    }
    
    func isEmpty () {
        self.dictionaryModel.isEmpty()
    }

}


