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
    
    private let libratyPath = "library"
    private let store = Firestore.firestore()
    @Published var libraryModel: LibraryModel = LibraryModel()
    
    init() {
        get()
    }
    
    func get() {
        store.collection(libratyPath).addSnapshotListener { snapshot, error in
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
        
        let dictionatyPath = dictionary.name
        
        do {
            _ = try store.collection(libratyPath).document(dictionatyPath).setData(from: dictionary)
        } catch {
            fatalError("Adding a dictionary failed")
        }
        
    }
}
