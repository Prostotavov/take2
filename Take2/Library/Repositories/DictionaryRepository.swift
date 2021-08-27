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
    
    private let path = "dictionary"
    private let store = Firestore.firestore()
    @Published var dictionary: DictionaryModel = DictionaryModel(name: "")
    
    init() {
        get()
    }
    
    func get() {
        store.collection(path).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            self.dictionary.addWords(words: snapshot?.documents.compactMap {
                try? $0.data(as: WordModel.self)
            } ?? [])
        }
    }
    
    func add(_ word: WordModel) {
        do {
            _ = try store.collection(path).addDocument(from: word)
        } catch {
            fatalError("Adding a word failed")
        }
        
    }
}
