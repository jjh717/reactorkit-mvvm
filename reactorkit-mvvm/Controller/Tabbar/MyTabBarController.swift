//
//  MyTabBarController.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import UIKit
import Then

final class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    private var serviceProvider = ServiceProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
         
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        MainController(reactor: MainReactor(provider: serviceProvider)).do {
            $0.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "list.dash"), selectedImage: UIImage(systemName: "list.dash"))
            
            self.addChild($0)
        }
        
        UINavigationController().do { searchNavigation in
            self.addChild(searchNavigation)
            
            SearchController(reactor: SearchReactor(provider: serviceProvider)).do {
                $0.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
                
                searchNavigation.viewControllers.append($0)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navi = viewController as? UINavigationController else { return }
        navi.popToRootViewController(animated: false)
    }
}
