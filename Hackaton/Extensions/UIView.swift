//
//  UIView.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(of view: UIView) -> [NSLayoutConstraint] {
            [
                topAnchor.constraint(equalTo: view.topAnchor),
                leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        }
}
