//
//  Menu.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/13.
//

import Foundation

struct MenuResponse: Decodable {
    let records: [Item]
}

struct Item: Decodable {
    let fields: Drink
    
    static let genres = { (drinks: [Item]) -> [String] in
        var allGenre = [String]()
        for i in 0..<drinks.count {
            let title = drinks[i].fields.genre
            allGenre.append(title)
        }
        allGenre = allGenre.removeDuplicateElement()
        return allGenre
    }
}

struct Drink: Decodable {
    let name: String
    let price: Int
    let description: String
    let genre: String
    let image: [Image]
    let caffeine: String
}

struct Image: Decodable {
    let url: URL
}


struct OrderPost: Codable {
    let records: [List]
}

struct List: Codable {
    let fields: DrinkDetail
}

struct DrinkDetail: Codable{
    let name: String
    let ice: String
    let sugar: String
    let quantity: Int
    let totalPrice: Int
    let orderTime: Date
}
