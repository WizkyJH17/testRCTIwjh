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
    
    private lazy var favoriteViewController: UIViewController = {
        let viewController: UINavigationController = generateTab(
            viewController: FavoriteViewController(),
            tabBarTitle: "Favorite",
            title: "Favorite Videos",
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
        setViewControllerList([homeViewController, favoriteViewController])
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

// MARK: - Show / Hide Function
extension TabBarController {
    func hideAnimated(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.layer.opacity = 0.0
        })
    }
    
    func showAnimated(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.layer.opacity = 1.0
        })
    }
}

// MARK: - UIViewController Extension
extension UIViewController {
    public func showTabBar() {
        guard let tabBar = navigationController?.tabBarController as? TabBarController else { return }
        tabBar.showAnimated()
    }
    
    public func hideTabBar() {
        guard let tabBar = navigationController?.tabBarController as? TabBarController else { return }
        tabBar.hideAnimated()
    }
}
