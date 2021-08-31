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
    @ServerTimestamp var createdTime: Timestamp?
    // MARK: super bad practice
    // нужно сделать либо обратный отсчет индексов, либо сделать ограничение на словарь
    // по словам, максимум 100000 слов в словаре
    var index = 100000
    
    // MARK: Future Feaches
    // В перспективе такие поля как: translate, analogy, hint
    // будут либо отдельными структурами, либо одной
    // так как одному слову может соответсовать несколько переводов
    // аналогий и подсказок
    var name: String
    var translate: String
    var analogy: String
    var hint: String
    
    init() {
        name = ""
        translate = ""
        analogy = ""
        hint = ""
    }
    
    init(name: String, translate: String, analogy: String, hint: String) {
        self.name = name
        self.translate = translate
        self.analogy = analogy
        self.hint = hint
    }
    
}
