//
//  MainTabBarController.swift
//  Hackaton
//
//  Created by Baytik  on 22/5/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let centerVC = UINavigationController(rootViewController: InputScreenViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        homeVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        centerVC.tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
        profileVC.tabBarItem = UITabBarItem(title: "Маалымат", image: UIImage(systemName: "questionmark.circle"), selectedImage: UIImage(systemName: "questionmark.circle"))
        
        self.viewControllers = [homeVC, centerVC, profileVC]
        
        tabBar.tintColor = UIColor(hex: "#50577AFF")
//        tabBar.tintColor = UIColor(hex: "#AEA1E5FF")
        tabBar.unselectedItemTintColor = UIColor(hex: "#A0A4B8FF")
        tabBar.tintColor = UIColor(hex: "#AEA1E5FF")
        
        setupMiddleButton()
    }
    
    private func setupMiddleButton() {
        let middleButton = UIButton()
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
//        middleButton.backgroundColor = UIColor(hex: "#56549EFF")
        middleButton.backgroundColor = UIColor(hex: "#6C63FFFF")
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 20
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        tabBar.addSubview(middleButton)
        
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10),
            middleButton.widthAnchor.constraint(equalToConstant: 56),
            middleButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func middleButtonTapped() {
        print("нажата кнопка +")
        
        if let selectedNav = self.selectedViewController as? UINavigationController {
            let inputVC = InputScreenViewController()
            selectedNav.pushViewController(inputVC, animated: true)
        }
    }
}
