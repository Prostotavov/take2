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
    private let wordsPath = "words"
    private let dictionaryPath: String
    private let db = Firestore.firestore()
    @Published var dictionaryModel: DictionaryModel
    
    init(dictionary: DictionaryModel) {
        self.dictionaryModel = dictionary
        self.dictionaryPath = dictionary.id ?? "dictionary"
        get()
    }

    func get() {
        db.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).order(by: "index")
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
            _ = try db.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).setData(from: word)
        } catch {
            fatalError("Adding a word failed")
        }
        self.setIndexIfAdd(word: word)
    }
    
    func remove(_ word: WordModel) {
        let removedId = word.index
        guard let wordPath = word.id else { return }
        db.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).document(wordPath).delete { error in
            if let error = error {
                print("Unable to remove this word: \(error.localizedDescription)")
            }
        }
        self.setIndexIfRemove(removedId: removedId)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { dictionaryModel.words[$0] }
            .forEach(self.remove)
        }
    
    func update(_ word: WordModel) {
        guard let wordPath = word.id else { return }
                db.collection(libraryPath).document(dictionaryPath)
                .collection(wordsPath).document(wordPath).updateData(["analogy":word.analogy,"hint":word.hint,
                     "name":word.name, "translate":word.translate])
    }

    func move(fromOffets indices: IndexSet,toOffsets newOffset: Int){
        let movedWord = dictionaryModel.findWordIn(indices)
        let oldIndex: Int = indices.min() ?? 0
        var newIndex: Int = newOffset
        if oldIndex < newIndex { newIndex -= 1 }
        // так как если oldIndex < newIndex, то newIndex почему то становится больше на 1
        changeIndex(in: movedWord, to: newIndex)
        
        for word in dictionaryModel.words {
            if oldIndex < newIndex {
                if (oldIndex...newIndex).contains(word.index) && word.id != movedWord.id {
                    changeIndex(in: word, to: word.index - 1)
                }
            } else {
                if (newIndex...oldIndex).contains(word.index) && word.id != movedWord.id {
                    changeIndex(in: word, to: word.index + 1)
                }
            }
        }
    }
    
    // MARK: Вспомогательные функции
    
    func setIndexIfAdd(word: WordModel) {
        db.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)");
            }
            else {
                var count = -1 // делаем так, чтобы индексация начиналась с нуля
                for _ in querySnapshot!.documents {
                    count += 1
                }
                self.changeIndex(in: word, to: count)
            }
        }
    }
    
    func setIndexIfRemove(removedId: Int) {
        for word in dictionaryModel.words {
            if word.index > removedId {
                changeIndex(in: word, to: word.index - 1)
            }
        }
    }
    
    func changeIndex(in word: WordModel, to newIndex: Int) {
        guard let wordPath = word.id else { return }
        db.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).document(wordPath)
            .updateData(["index" : newIndex])
    }
    
}
