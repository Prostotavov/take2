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
    let wordsPath = "words"
    var dictionaryPath: String = "dictionary"
    private let store = Firestore.firestore()
    @Published var dictionary: DictionaryModel
    
    init(dictionary: DictionaryModel) {
        self.dictionary = dictionary
        dictionaryPath = dictionary.name
        get()
    }
    
    func get() {
        
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
    
    func add(_ word: WordModel) {
        
        let wordPath = word.name
        
        do {
            _ = try store.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).setData(from: word)
        } catch {
            fatalError("Adding a word failed")
        }
        
    }
    
    func delete(_ words: WordModel) {
        
        guard let documentId = words.id else { return }
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).document(documentId).delete { error in
            if let error = error {
                print("Unable to remove this word: \(error.localizedDescription)")
            }
        }
    }
    
    func update(_ dictionary: DictionaryModel) {
        guard let documentId = dictionary.id else { return }
        
        do {
            try store.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(documentId).setData(from: dictionary)
        } catch {
            fatalError("Updating a word failed")
        }
    }
}
