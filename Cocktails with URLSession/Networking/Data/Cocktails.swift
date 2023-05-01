//
//  Cocktails.swift
//  Cocktails with URLSession
//
//  Created by Marina Andrés Aragón on 1/5/23.
//

import Foundation

// MARK: - Cocktails
struct Cocktails: Decodable {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink: Decodable {
    let strDrink: String
    let strDrinkThumb: String
   
}
