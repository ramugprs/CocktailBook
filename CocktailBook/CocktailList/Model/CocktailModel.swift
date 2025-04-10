//
//  CocktailModel.swift
//  CocktailBook
//
//  Created by Ramakrishna.Goparapu on 10/04/25.
//

import Foundation

struct CocktailModel: Identifiable, Codable {
    var id: String
    var name: String
    var type: String
    var shortDescription: String
    var longDescription: String
    var preparationMinutes: Int
    var imageName: String
    var ingredients: [String]
    var isFav: Bool?
}
