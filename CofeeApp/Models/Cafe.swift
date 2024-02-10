//
//  Cafe.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 10.02.2024.
//

import Foundation

struct Cafe: Codable {
    var id: Int
    var name: String
    var point: Point
}

// MARK: - Point
struct Point: Codable {
    let latitude, longitude: String
}
