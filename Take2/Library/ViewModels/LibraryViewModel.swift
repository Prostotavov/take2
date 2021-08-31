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
    
    func add(_ dictionaries: DictionaryModel) {
        libraryRepository.add(dictionaries)
    }
    
    func remove(_ dictionary: DictionaryModel) {
        libraryRepository.remove(dictionary)
    }
    
    func delete(at offsets: IndexSet) {
        libraryRepository.delete(at: offsets)
        } 
    
    func update(_ dictionary: DictionaryModel) {
        libraryRepository.update(dictionary)
    }
    
    func choose(dict: DictionaryModel) -> DictionaryModel {
        libraryModel.choose(dict: dict)
    }
    
    func move(indices: IndexSet, newOffset: Int) {
        libraryRepository.move(indices: indices, newOffset: newOffset)
    }
    
    func findDictionaryByIndex(indices: IndexSet) -> DictionaryModel {
        libraryModel.findDictionaryByIndex(indices: indices)
    }
    
    // MARK: functions for debug
    
    func printContent () {
        libraryModel.printContent()
    }
    
}


