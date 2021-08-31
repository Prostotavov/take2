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
    private let store = Firestore.firestore()
    @Published var libraryModel: LibraryModel = LibraryModel()
    
    init() {
        get()
    }
    
    func get() {
        
        store.collection(libraryPath).order(by: "usersOrder")
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
            _ = try store.collection(libraryPath).document(dictionaryPath).setData(from: dictionary)
        } catch {
            fatalError("Adding a dictionary failed")
        }
        self.setUsersOrderIfAdd(dictionaryPath: dictionaryPath)
    }
    
    func remove(_ dictionary: DictionaryModel) {
        
        let removedId = dictionary.usersOrder
        guard let dictionaryPath = dictionary.id else { return }
        
        // MARK: Super bad practice
        // когда выучу как работать с потоками, то нужно будет отрефакторить тут все.
        
        // записываем в переменную tempDict слова, которые хранятся в словаре
        var tempDict = DictionaryModel(name: "temporary")
        
        // извлекаем слова из бд в tempDict
        store.collection(libraryPath).document(dictionaryPath)
            .collection(wordsPath).order(by: "usersOrder")
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
                    print("something working3")
                    guard let wordPath = word.id else { return }
                    self.store.collection(self.libraryPath).document(dictionaryPath)
                        .collection(self.wordsPath).document(wordPath).delete { error in
                        if let error = error {
                            print("Unable to remove these words in the dictionary: \(error.localizedDescription)")
                        }
                    }
                }
        }
        
        // удаление словаря
        store.collection(libraryPath).document(dictionaryPath).delete { error in
            if let error = error {
                print("Unable to remove this dictionary: \(error.localizedDescription)")
            }
        }
        self.setUsersOrderIfRemove(removedId: removedId)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { libraryModel.dictionaries[$0] }
            .forEach(self.remove)
        }
    
    func update(_ dictionary: DictionaryModel) {
        
        guard let dictionaryPath = dictionary.id else { return }
                store.collection(libraryPath).document(dictionaryPath)
                    .updateData(["name" : dictionary.name ])
    }
    
    func setUsersOrderIfAdd(dictionaryPath: String) {
        
        store.collection(libraryPath).getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)");
            }
            else {
                var count = -1 // делаем так, чтобы индексация начиналась с нуля
                for _ in querySnapshot!.documents {
                    count += 1
                }
                self.store.collection(self.libraryPath).document(dictionaryPath)
                    .updateData(["usersOrder" : count ])
            }
        }
    }
    
    func setUsersOrderIfRemove(removedId: Int) {
        
        for dictionary in libraryModel.dictionaries {
        guard let dictionaryPath = dictionary.id else { return }
            if dictionary.usersOrder > removedId {
                self.store.collection(self.libraryPath).document(dictionaryPath)
                    .updateData(["usersOrder" : dictionary.usersOrder - 1 ])
            }
        }
    }
    
    func move(indices: IndexSet, newOffset: Int){
        
        let movedDict = libraryModel.findDictionaryByIndex(indices: indices)
        
        let oldIndex: Int = indices.min() ?? 0
        var newIndex: Int = newOffset
        // так как если oldIndex < newIndex, то newIndex почему то становится больше на 1
        if oldIndex < newIndex { newIndex -= 1 }
        
        for dictionary in libraryModel.dictionaries {
            guard let dictionaryPath = dictionary.id else { return }
            // так как элемент может перемещаться как вниз, так и вверх
            if oldIndex < newIndex {
                if  (oldIndex...newIndex).contains(dictionary.usersOrder) && dictionary.id != movedDict.id {
                    self.store.collection(self.libraryPath).document(dictionaryPath)
                        .updateData(["usersOrder" : dictionary.usersOrder - 1 ])
                }
            } else {
                if (newIndex...oldIndex).contains(dictionary.usersOrder) && dictionary.id != movedDict.id {
                    self.store.collection(self.libraryPath).document(dictionaryPath)
                        .updateData(["usersOrder" : dictionary.usersOrder + 1 ])
                }
            }
        }
        
        guard let movedDictPath = movedDict.id else { return }
        self.store.collection(self.libraryPath).document(movedDictPath)
            .updateData(["usersOrder" : newIndex ])
    }

}

