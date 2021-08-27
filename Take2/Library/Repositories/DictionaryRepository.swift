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
        self.dictionaryPath = dictionary.id ?? "dictionary"
        get()
    }
    
    func get() {
        
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            // MARK: Bad practice
            // нужно реализовать добавление словарей по одному
            // а не стирать все словари и записывать все заново и плюс один новый
            self.dictionary.deleleAllWords()
            self.dictionary.addWords(words: snapshot?.documents.compactMap {
                try? $0.data(as: WordModel.self)
            } ?? [])
        }
    }
    
    func add(_ word: WordModel) {
        
        guard let wordPath = word.id else { return }
        do {
            _ = try store.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).setData(from: word)
        } catch {
            fatalError("Adding a word failed")
        }
        
    }
    
    func delete(_ word: WordModel) {
        guard let wordPath = word.id else { return }
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).document(wordPath).delete { error in
            if let error = error {
                print("Unable to remove this word: \(error.localizedDescription)")
            }
        }
    }
    
    func update(_ word: WordModel) {
        guard let wordPath = word.id else { return }
                store.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).updateData(["analogy":word.analogy,"hint":word.hint,
                     "name":word.name, "translate":word.translate])
    }
}
