//
//  UIColor.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r, g, b, a: CGFloat
        
        switch hexSanitized.count {
        case 8: // RRGGBBAA
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255
            a = CGFloat(rgb & 0x000000FF) / 255
        case 6: // RRGGBB (без альфы)
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            b = CGFloat(rgb & 0x0000FF) / 255
            a = 1
        default:
            r = 1; g = 0; b = 0; a = 1
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

