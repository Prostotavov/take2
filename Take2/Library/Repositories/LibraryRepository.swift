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
    
    private let path = "library"
    private let store = Firestore.firestore()
    @Published var libraryModel: LibraryModel = LibraryModel()
    
    init() {
        get()
    }
    
    func get() {
        store.collection(path).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            self.libraryModel.addDictionaries(dictionaries: snapshot?.documents.compactMap {
                try? $0.data(as: DictionaryModel.self)
            } ?? [])
        }
    }
    
    func add(_ dictionary: DictionaryModel) {
        do {
            _ = try store.collection(path).addDocument(from: dictionary)
        } catch {
            fatalError("Adding a dictionary failed")
        }
        
    }
}