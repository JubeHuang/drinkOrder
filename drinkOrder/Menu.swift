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
    
//    static func getGenreDrink(drinks: [Item], _ genre: [String]) -> [[Item]] {
//        var tabDrinks = [Item]()
//        var allTabDrinks = [[Item]]()
//        for (_, drink) in drinks.enumerated(){
//            for i in 0..<genre.count {
//                if drink.fields.genre == genre[i] {
//                    tabDrinks.append(drink)
//                }
//            }
//            allTabDrinks.append(tabDrinks)
//        }
//        return allTabDrinks
//    }
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
