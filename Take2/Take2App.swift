//
//  Take2App.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import SwiftUI

@main
struct Take2App: App {
    
    static let library = LibraryViewModel()
    
    var body: some Scene {
        WindowGroup {
            LibraryView(libraryViewModel: Take2App.library)
        }
    }
}
