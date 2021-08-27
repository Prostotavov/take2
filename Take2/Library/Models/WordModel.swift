//
//  Word.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct WordModel: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    var name: String
    var translate: String
    var analogy: String
    var hint: String
    
    // MARK: functions for debug
    
    func getID() -> String? {
        return self.id
    }
    
}
