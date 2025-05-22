//
//  String.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
