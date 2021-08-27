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
    
    func add(_ dictionaries: DictionaryModel) {
        libraryRepository.add(dictionaries)
    }
    
    func remove(_ dictionary: DictionaryModel) {
        libraryRepository.remove(dictionary)
    }
    
    func update(_ dictionary: DictionaryModel) {
        libraryRepository.update(dictionary)
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


