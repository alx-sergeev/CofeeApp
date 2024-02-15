//
//  Product.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 12.02.2024.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let name, imageURL: String?
    let price: Int?
}
