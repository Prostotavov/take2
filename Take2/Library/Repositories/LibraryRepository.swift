//
//  LibraryRepository.swift
//  Take2
//
//  Created by MacBook Pro on 26.08.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import UIKit


final class LibraryRepository: ObservableObject {
    
    private let libraryPath = "library"
    private let store = Firestore.firestore()
    @Published var libraryModel: LibraryModel = LibraryModel()
    
    init() {
        get()
    }
    
    func get() {
        
        store.collection(libraryPath).order(by: "createdTime")
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
        store.collection(libraryPath).document(dictionaryPath).delete { error in
            if let error = error {
                print("Unable to remove this dictionary: \(error.localizedDescription)")
            }
        }
        self.setUsersOrderIfRemove(removedId: removedId)
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

}

