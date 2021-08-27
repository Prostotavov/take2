//
//  LibraryViewModel.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    
    @Published var libraryRepository = LibraryRepository()
    @Published private var libraryModel: LibraryModel = LibraryModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    var dictionaries: Array<DictionaryModel> {
        return libraryModel.dictionaries
    }
    
    init() {
        libraryRepository.$libraryModel
            .assign(to: \.libraryModel, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: Bad Practice
    // нужно удалить ненужные функции и переименовать оставшиеся
    
    func addDictionaryToRepository(_ dictionaries: DictionaryModel) {
        libraryRepository.add(dictionaries)
    }
    
    func deleteDictionaryFromRepository(_ dictionary: DictionaryModel) {
        libraryRepository.delete(dictionary)
    }
    
    func updateDictionaryByRepository(_ dictionary: DictionaryModel) {
        libraryRepository.update(dictionary)
    }
    
    func addDictionary(dictionary: DictionaryModel) {
        libraryModel.addDictionary(dictionary: dictionary)
    }
    
    func deleteDictionary(at indexSet: IndexSet) {
        libraryModel.deleteDictionary(at: indexSet)
    }
    
    func choose(dict: DictionaryModel) -> DictionaryModel {
        libraryModel.choose(dict: dict)
    }
    
    func moveDictionary(indices: IndexSet, newOffset: Int) {
        libraryModel.moveDictionary(indices: indices, newOffset: newOffset)
    }
    
    // MARK: functions for debug
    
    func printContent () {
        libraryModel.printContent()
    }
    
}


