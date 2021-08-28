//
//  DictionaryViewModel.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift



class DictionaryViewModel: ObservableObject {
        
    @Published var dictionaryRepository: DictionaryRepository
    @Published private var dictionaryModel: DictionaryModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    var name: String {
        return dictionaryModel.name
    }
    
    var usersOrder: Int {
        return dictionaryModel.usersOrder
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
    
    // MARK: Bad Practice
    // нужно удалить ненужные функции и переименовать оставшиеся
    
    func add(_ words: WordModel) {
        dictionaryRepository.add(words)
    }
    
    func remove(_ word: WordModel) {
        dictionaryRepository.remove(word)
    }

    func update(_ word: WordModel) {
        dictionaryRepository.update(word)
    }
    
    func choose(word: WordModel) -> Int {
        dictionaryModel.choose(word: word)
    }
    
    func moveWord(indices: IndexSet, newOffset: Int) {
        dictionaryModel.moveWord(indices: indices, newOffset: newOffset)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { dictionaryModel.words[$0] }
            .forEach(self.remove)
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


