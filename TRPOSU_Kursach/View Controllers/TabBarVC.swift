//
//  TabBarControllerViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 30.10.22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewControllersConfig()
        self.tabBarConfig()
    }
    
    private func tabBarConfig()
    {
        self.tabBar.tintColor = Sources.Colors.systemColor
        self.tabBar.unselectedItemTintColor = .systemGray
        
        let appearance = UITabBarAppearance()
        appearance.accessibilityNavigationStyle = .separate
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    private func viewControllersConfig()
    {
        let navigationGalleryVC = UINavigationController(rootViewController: GalleryViewController())
        navigationGalleryVC.tabBarItem.title = "Gallery"
        navigationGalleryVC.tabBarItem.image = UIImage(systemName: "book.fill")
        
        let navigatioCartVC = UINavigationController(rootViewController: CartViewController())
        navigatioCartVC.tabBarItem.title = "Cart"
        navigatioCartVC.tabBarItem.image = UIImage(systemName: "cart.fill")
        
        self.viewControllers = [navigationGalleryVC, navigatioCartVC]
    }
}
