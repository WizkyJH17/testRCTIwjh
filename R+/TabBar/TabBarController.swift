//
//  TabBarController.swift
//  R+
//
//  Created by William Johanssen Hutama on 04/07/24.
//

import UIKit

// MARK: - Tab Bar Controller
class TabBarController: UITabBarController {
    // Variable
    private lazy var homeViewController: UIViewController = {
        let viewController: UINavigationController = generateTab(
            viewController: HomeViewController(),
            tabBarTitle: "Home",
            title: "Home",
            icon: UIImage(systemName: "house")
        )
        return viewController
    }()
    
    private lazy var favouriteViewController: UIViewController = {
        let viewController: UINavigationController = generateTab(
            viewController: FavouriteViewController(),
            tabBarTitle: "Favourite",
            title: "Favourite Videos",
            icon: UIImage(systemName: "heart")
        )
        return viewController
    }()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

// MARK: - Tab Bar Setup
extension TabBarController {
    // Main
    private func setupTabBar() {
        setBackgroundColor(.clear)
        setViewControllerList([homeViewController, favouriteViewController])
    }
    
    // Sub
    private func setBackgroundColor(_ color: UIColor) {
        tabBar.backgroundColor = color
    }
    
    private func setViewControllerList(_ viewControllerList: [UIViewController]) {
        setViewControllers(viewControllerList, animated: true)
    }
}

// MARK: - Private Function
extension TabBarController {
    private func generateTab(viewController: UIViewController, tabBarTitle: String, title: String, icon: UIImage?) -> UINavigationController {
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = tabBarTitle
        navigationController.tabBarItem.image = icon
        navigationController.viewControllers.first?.navigationItem.title = title
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}
