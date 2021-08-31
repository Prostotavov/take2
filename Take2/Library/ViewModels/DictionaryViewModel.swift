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
        dictionaryRepository.$dictionaryModel
            .assign(to: \.dictionaryModel, on: self)
            .store(in: &cancellables)
    }
    
    func add(_ words: WordModel) {
        dictionaryRepository.add(words)
    }
    
    func remove(_ word: WordModel) {
        dictionaryRepository.remove(word)
    }
    
    func delete(at offsets: IndexSet) {
        dictionaryRepository.delete(at: offsets)
        }

    func update(_ word: WordModel) {
        dictionaryRepository.update(word)
    }
    
    func choose(word: WordModel) -> Int {
        dictionaryModel.choose(word: word)
    }
    
    func findWordByIndex(indices: IndexSet) -> WordModel {
        dictionaryModel.findWordByIndex(indices: indices)
    }
    
    func move(indices: IndexSet, newOffset: Int) {
        dictionaryRepository.move(indices: indices, newOffset: newOffset)
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


