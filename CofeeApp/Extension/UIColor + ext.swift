//
//  UIColor + ext.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static let navBarBackgroundColor: UIColor = .init(hexString: "FAF9F9")
    static let navBarShadowColor: UIColor = .init(hexString: "C2C2C2")
    static let textDefaultColor: UIColor = .init(hexString: "846340")
    static let textSecondColor: UIColor = .init(hexString: "AF9479")
    static let buttonBackgroundColor: UIColor = .init(hexString: "342D1A")
    static let tableCellBackgroundColor: UIColor = .init(hexString: "F6E5D1")
    
}
