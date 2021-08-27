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
    private let store = Firestore.firestore()
    @Published var libraryModel: LibraryModel = LibraryModel()
    
    init() {
        get()
    }
    
    func get() {
        store.collection(libraryPath).addSnapshotListener { snapshot, error in
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
        
        let dictionatyPath = dictionary.name
        
        do {
            _ = try store.collection(libraryPath).document(dictionatyPath).setData(from: dictionary)
        } catch {
            fatalError("Adding a dictionary failed")
        }
    }
    
    func delete(_ dictionary: DictionaryModel) {
        
        // MARK: Bad practice2
        // лучше передавать ссылку одним и тем же способом
        // а то здесь это происходит с помощью 'let documentId'
        // а в другой половине проекта с 'dictionatyPath'
        guard let documentId = dictionary.id else { return }
        store.collection(libraryPath).document(documentId).delete { error in
            if let error = error {
                print("Unable to remove this dictionary: \(error.localizedDescription)")
            }
        }
    }
    
    func update(_ dictionary: DictionaryModel) {
        guard let documentId = dictionary.id else { return }
        
        do {
            try store.collection(libraryPath).document(documentId).setData(from: dictionary)
        } catch {
            fatalError("Updating a dictionary failed")
        }
    }
    
}
