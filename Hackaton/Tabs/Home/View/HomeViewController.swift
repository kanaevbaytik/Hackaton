//
//  HomeViewController.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import Foundation
import UIKit

class HomeViewController: UIViewController { 
    
    private lazy var viewManager: ViewManager = {
        ViewManager(controller: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#464C75FF")
        title = "Башкы бет"
        viewManager.createAppHeader(title: "Кыргыз дүйнөсү")
        viewManager.createCards()
        viewManager.createService()
        
    }
}
