//
//  AuthResponse.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import Foundation

struct AuthResponse: Decodable {
    var token: String
    var tokenLifetime: Int?
}
