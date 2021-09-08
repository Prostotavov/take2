//
//  LibraryRepository.swift
//  Take2
//
//  Created by MacBook Pro on 26.08.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class LibraryRepository: ObservableObject {
    
    private let libraryPath = "library"
    private let wordsPath = "words"
    private let db = Firestore.firestore()
    @Published var libraryModel: LibraryModel = LibraryModel()
    
    init() {
        get()
    }
    
    func get() {
        db.collection(libraryPath).order(by: "index")
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            // MARK: Bad practice
            // нужно реализовать добавление словарей по одному
            // а не стирать все словари и записывать все заново и плюс один новый
            self.libraryModel.deleleAllDictionaries()
            self.libraryModel.addDictionaries(dictionaries: snapshot?.documents.compactMap {
                try? $0.data(as: DictionaryModel.self)
            } ?? [])
        }
    }
    
    func add(_ dictionary: DictionaryModel) {
        guard let dictionaryPath = dictionary.id else { return }
        do {
            _ = try db.collection(libraryPath).document(dictionaryPath).setData(from: dictionary)
        } catch {
            fatalError("Adding a dictionary failed")
        }
        self.setIndexIfAdd(dictionary: dictionary)
    }
    
    func remove(_ dictionary: DictionaryModel) {
        let removedId = dictionary.index
        guard let dictionaryPath = dictionary.id else { return }
        
        // MARK: Super bad practice
        // когда выучу как работать с потоками, то нужно будет отрефакторить тут все.
        
        // записываем в переменную tempDict слова, которые хранятся в словаре
        var tempDict = DictionaryModel(name: "temporary")
        
        // извлекаем слова из бд в tempDict
        db.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).order(by: "index")
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            tempDict.deleleAllWords()
            tempDict.addWords(words: snapshot?.documents.compactMap {
                try? $0.data(as: WordModel.self)
            } ?? [])
                
                // удаляем слова в словаре
                for word in tempDict.words {
                    guard let wordPath = word.id else { return }
                    self.db.collection(self.libraryPath).document(dictionaryPath)
                        .collection(self.wordsPath).document(wordPath).delete { error in
                        if let error = error {
                            print("Unable to remove these words in the dictionary: \(error.localizedDescription)")
                        }
                    }
                }
        }
        
        // удаление словаря
        db.collection(libraryPath).document(dictionaryPath).delete { error in
            if let error = error {
                print("Unable to remove this dictionary: \(error.localizedDescription)")
            }
        }
        self.setIndexIfRemove(removedId: removedId)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { libraryModel.dictionaries[$0] }
            .forEach(self.remove)
        }
    
    func update(_ dictionary: DictionaryModel) {
        guard let dictionaryPath = dictionary.id else { return }
                db.collection(libraryPath).document(dictionaryPath)
                    .updateData(["name" : dictionary.name ])
    }
    
    func updateIndex(_ dictionary: DictionaryModel) {
        guard let dictionaryPath = dictionary.id else { return }
        db.collection(libraryPath).document(dictionaryPath)
            .updateData(["index" : dictionary.index ])
    }
    
    func updateIndices(fromOffsets indices: IndexSet, toOffset newOffset: Int, dictionaries: [DictionaryModel]) {
        let oldIndex: Int = indices.min() ?? 0
        var newIndex: Int = newOffset
        if oldIndex < newIndex { newIndex -= 1 }
        // так как если oldIndex < newIndex, то newIndex почему то становится больше на 1
        for dictionary in dictionaries {
            if oldIndex < newIndex {
                if (oldIndex...newIndex).contains(dictionary.index) {
                    updateIndex(dictionary)
                }
            } else {
                if (newIndex...oldIndex).contains(dictionary.index) {
                    updateIndex(dictionary)
                }
            }
        }
    }
    
    func move(fromOffets indices: IndexSet,toOffsets newOffset: Int){
        let movedDict = libraryModel.findDictionaryIn(indices)
        let oldIndex: Int = indices.min() ?? 0
        var newIndex: Int = newOffset
        if oldIndex < newIndex { newIndex -= 1 }
        // тк если oldIndex < newIndex, то newIndex почему то становится больше на 1
        changeIndex(in: movedDict, to: newIndex)
        
        for dictionary in libraryModel.dictionaries {
            if oldIndex < newIndex {
                if  (oldIndex...newIndex).contains(dictionary.index) && dictionary.id != movedDict.id {
                    changeIndex(in: dictionary, to: dictionary.index - 1)
                }
            } else {
                if (newIndex...oldIndex).contains(dictionary.index) && dictionary.id != movedDict.id {
                    changeIndex(in: dictionary, to: dictionary.index + 1)
                }
            }
        }
    }
    
    // MARK: Вспомогательные функции

    func setIndexIfRemove(removedId: Int) {
        for dictionary in libraryModel.dictionaries {
            if dictionary.index > removedId {
                changeIndex(in: dictionary, to: dictionary.index - 1)
            }
        }
    }
    
    func setIndexIfAdd(dictionary: DictionaryModel) {
        db.collection(libraryPath).getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)");
            }
            else {
                var count = -1 // делаем так, чтобы индексация начиналась с нуля
                for _ in querySnapshot!.documents {
                    count += 1
                }
                self.changeIndex(in: dictionary, to: count)
            }
        }
    }
    
    func changeIndex(in dictionary: DictionaryModel, to newIndex: Int) {
        guard let dictionaryPath = dictionary.id else { return }
        db.collection(libraryPath).document(dictionaryPath)
            .updateData(["index" : newIndex])
    }
    
}

