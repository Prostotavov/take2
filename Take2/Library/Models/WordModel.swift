//
//  Word.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import Foundation

struct Word: Identifiable {
    
    var id = UUID()
    var name: String
    var translate: String
    var analogy: String
    var hint: String
    
    // MARK: functions for debug
    
    func getID() -> UUID {
        return self.id
    }
    
}
