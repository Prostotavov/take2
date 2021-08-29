//
//  Dictionary.swift
//  Take2
//
//  Created by MacBook Pro on 2.06.21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct DictionaryModel: Identifiable, Codable {
    
    @DocumentID var id = UUID().uuidString
    @ServerTimestamp var createdTime: Timestamp?
    // MARK: super bad practice
    // нужно сделать либо обратный отсчет индексов, либо сделать ограничение на словарь
    // по словам, максимум 100000 словарей в библиотеке
    var usersOrder = 100000
    
    // MARK: Future Feaches
    // В будущем можно будет изменять название словаря
    var name: String
    
    private(set) var words: Array<WordModel>
    
    init(name: String) {
        self.name = name
        self.words = Array<WordModel>()
        // MARK: Bad Practice
        // Лучше всего делать отдельную структуру для дебага
        // и так ее и назвать 'struct Debage'
        // там будет вся логика и все нужные функции.
        // лучше всего реализовать в ней удобные инициализаторы(convinient init)
        // чтобы структура реализовывала нужные нам функции
        print("DM init name")
    } 
    
    // MARK: Bad Practice2
    // нужно удалить ненужные функции и переименовать оставшиеся
    
    
    mutating func addWords(words: [WordModel]) {
        for word in words {
            self.words.append(word)
        }
    }
    
    mutating func deleleAllWords() {
        words = []
    }

    func choose(word: WordModel) -> Int {
        let index = words.firstIndex(where: { $0.id == word.id }) ?? 0
        return index
    }
    
    func findWordByUsersOrder(usersOrder: Int) -> WordModel? {
        for word in words {
            if word.usersOrder == usersOrder {
                return word
            }
        }
        return nil
    }
    
    // MARK: functions for debug
    
    func printContent () {
        words.forEach { print($0.name) }
    }
    
    func getID() -> String? {
        return self.id
    }
    
    func isEmpty() {
        if !self.words.isEmpty {
            self.printContent()
        }
        else {
            print("Array of words is empty")
        }
    }
    
}
