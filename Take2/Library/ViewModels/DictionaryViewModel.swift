//
//  DictionaryViewModel.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
        
    @Published var dictionaryRepository: DictionaryRepository
    @Published private var dictionaryModel: DictionaryModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    var name: String {
        return dictionaryModel.name
    }
    
    var words: Array<WordModel> {
        return dictionaryModel.words
    }
    
    init(dictionaryModel: DictionaryModel) {
        self.dictionaryModel = dictionaryModel
        self.dictionaryRepository = DictionaryRepository(dictionary: dictionaryModel)
        dictionaryRepository.$dictionary
            .assign(to: \.dictionaryModel, on: self)
            .store(in: &cancellables)
        
        print(dictionaryModel.name)
        print("DVM init for \(self.dictionaryModel.getID() ?? "")")
        dictionaryModel.printContent()
    }
    
    func addWordToRepository(_ words: WordModel) {
        dictionaryRepository.add(words)
    }
    
    func deleteWordFromRepository(_ word: WordModel) {
        dictionaryRepository.delete(word)
    }

    
    func addWord(word: WordModel) {
        dictionaryModel.addWord(word: word)
    }
    
    func deleteWord(at indexSet: IndexSet) {
        dictionaryModel.deleteWord(at: indexSet)
    }
    
    func editWord(index: Int, newWord: WordModel) {
        dictionaryModel.editWord(index: index, newWord: newWord)
    }
    
    func choose(word: WordModel) -> Int {
        dictionaryModel.choose(word: word)
    }
    
    func moveWord(indices: IndexSet, newOffset: Int) {
        dictionaryModel.moveWord(indices: indices, newOffset: newOffset)
    }
    
    // MARK: functions for debug
    
    func printContent () {
        dictionaryModel.printContent()
    }
    
    func getID() -> String? {
        return dictionaryModel.getID()
    }
    
    func isEmpty () {
        self.dictionaryModel.isEmpty()
    }

}


