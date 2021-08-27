//
//  DictionaryRepository.swift
//  StadyCards
//
//  Created by MacBook Pro on 26.08.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class DictionaryRepository: ObservableObject {
    
    private let libraryPath = "library"
    var dictionaryPath: String = "dictionary"
    private let store = Firestore.firestore()
    @Published var dictionary: DictionaryModel
    
    init(dictionary: DictionaryModel) {
        self.dictionary = dictionary
        dictionaryPath = dictionary.name
        get()
    }
    
    func get() {
        
        let wordsPath = "words"
        
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            self.dictionary.addWords(words: snapshot?.documents.compactMap {
                try? $0.data(as: WordModel.self)
            } ?? [])
        }
    }
    
    func add(_ word: WordModel, dictionaryPath: String) {
        
        let wordsPath = "words"
        let wordPath = word.name
        
        do {
            _ = try store.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).setData(from: word)
        } catch {
            fatalError("Adding a word failed")
        }
        
    }
}
