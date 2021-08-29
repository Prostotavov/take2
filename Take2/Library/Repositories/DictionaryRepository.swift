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
    @Published var dictionaryModel: DictionaryModel
    
    init(dictionary: DictionaryModel) {
        self.dictionaryModel = dictionary
        self.dictionaryPath = dictionary.id ?? "dictionary"
        get()
    }
    
    func get() {
        
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).order(by: "usersOrder")
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            // MARK: Bad practice
            // нужно реализовать добавление словарей по одному
            // а не стирать все словари и записывать все заново и плюс один новый
            self.dictionaryModel.deleleAllWords()
            self.dictionaryModel.addWords(words: snapshot?.documents.compactMap {
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
        self.setUsersOrderIfAdd(wordPath: wordPath)
    }
    
    func remove(_ word: WordModel) {
        
        let removedId = word.usersOrder
        guard let wordPath = word.id else { return }
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).document(wordPath).delete { error in
            if let error = error {
                print("Unable to remove this word: \(error.localizedDescription)")
            }
        }
        self.setUsersOrderIfRemove(removedId: removedId)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { dictionaryModel.words[$0] }
            .forEach(self.remove)
        }
    
    func update(_ word: WordModel) {
        
        guard let wordPath = word.id else { return }
                store.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).updateData(["analogy":word.analogy,"hint":word.hint,
                     "name":word.name, "translate":word.translate])
    }
    
    func setUsersOrderIfAdd(wordPath: String) {
        
        store.collection(libraryPath).document(self.dictionaryPath)
            .collection(self.wordsPath).getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)");
            }
            else {
                var count = -1 // делаем так, чтобы индексация начиналась с нуля
                for _ in querySnapshot!.documents {
                    count += 1
                }
                self.store.collection(self.libraryPath).document(self.dictionaryPath)
                    .collection(self.wordsPath).document(wordPath)
                    .updateData(["usersOrder" : count ])
            }
        }
    }
    
    func setUsersOrderIfRemove(removedId: Int) {
        
        for word in dictionaryModel.words {
        guard let wordPath = word.id else { return }
            if word.usersOrder > removedId {
                self.store.collection(self.libraryPath).document(dictionaryPath)
                    .collection(self.wordsPath).document(wordPath)
                    .updateData(["usersOrder" : word.usersOrder - 1 ])
            }
        }
    }
    
    func move(oldIndex: Int, newIndex: Int, movedWord: WordModel){
        
        for word in dictionaryModel.words {
            guard let wordPath = word.id else { return }
            // так как элемент может перемещаться как вниз, так и вверх
            if oldIndex < newIndex {
                if (oldIndex...newIndex).contains(word.usersOrder) {
                    self.store.collection(self.libraryPath).document(dictionaryPath)
                        .collection(self.wordsPath).document(wordPath)
                        .updateData(["usersOrder" : word.usersOrder - 1 ])
                }
            } else {
                if (newIndex...oldIndex).contains(word.usersOrder) {
                    self.store.collection(self.libraryPath).document(dictionaryPath)
                        .collection(self.wordsPath).document(wordPath)
                        .updateData(["usersOrder" : word.usersOrder + 1 ])
                }
            }
        }
        
        guard let movedWordPath = movedWord.id else { return }
        self.store.collection(self.libraryPath).document(dictionaryPath)
            .collection(self.wordsPath).document(movedWordPath)
            .updateData(["usersOrder" : newIndex ])
    }

}
