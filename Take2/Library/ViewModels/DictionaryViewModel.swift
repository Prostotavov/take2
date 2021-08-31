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
        return dictionaryModel.index
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
    
    func findWordIn(_ indices: IndexSet) -> WordModel {
        dictionaryModel.findWordIn(indices)
    }
    
    func move(fromOffets indices: IndexSet,toOffsets newOffset: Int) {
        dictionaryRepository.move(fromOffets: indices, toOffsets: newOffset)
    }

}


