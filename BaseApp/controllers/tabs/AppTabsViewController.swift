//
//  AppTabsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit
import Combine

enum CartViewState {
    case visible
    case hidden
}

class AppTabsViewController: UITabBarController, UINavigationControllerDelegate {
    let instance: ViewCartFloatingView = ViewCartFloatingView.newInstance()
    private let viewModel: PopUpsViewModel = PopUpsViewModel()
    private let homeVc = HomeViewController()
    private let profileVc = ProfileViewController()
    private var exploreNav: UINavigationController?
    private let cartViewModel: CartViewModel = CartViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    private var explore: ExploreViewController? = nil
    private var thereIsCart: Bool = false
    
    private let cartVC = CartViewController()

    private var cartViewState: CartViewState = .hidden {
        didSet {
            switch cartViewState {
            case .visible:
                self.adjustFloatingViewVisibility(isVisible: true, animated: true)
            case .hidden:
                self.adjustFloatingViewVisibility(isVisible: false, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Profile remains unchanged
        profileVc.tabBarItem = UITabBarItem(
            title: "Profile".localized,
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profile_selected")
        )
        cartVC.tabBarItem = UITabBarItem(
            title: "Cart".localized,
            image: UIImage(named: "shopping-cart"),
            selectedImage: UIImage(named: "grocery-store")
        )

        // Create Explore tab first (with Home icons)
        exploreNav = createExploreTab()
        
        // Create Home tab second (with Explore icons)
        let homeNav = createHomeTab()
        
        // Build Profile nav
        let profileNav = UINavigationController(rootViewController: profileVc)
        profileNav.delegate = self
        profileNav.setNavigationBarHidden(true, animated: false)
        profileNav.definesPresentationContext = true
        
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.delegate = self
        cartNav.setNavigationBarHidden(true, animated: false)
        cartNav.definesPresentationContext = true

        // Set tabs
        self.view.backgroundColor = .white
        
        // disable carttab
        viewControllers = [exploreNav ?? UINavigationController(), homeNav, cartNav,profileNav]
        
        // Prepare tab bar appearance
        setupTabBar()
        
        // Load cart info
        reloadCart()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageChanged),
            name: Notification.Name(rawValue: "LanguageChanged"),
            object: nil
        )
    }

    func setupTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundEffect = nil
        tabBarAppearance.backgroundColor = UIColor(red: 0.24, green: 0.16, blue: 0.73, alpha: 1)
        tabBarAppearance.shadowColor = .clear
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .white
        tabBar.layer.cornerRadius = 24
        tabBar.layer.masksToBounds = true
        tabBar.clipsToBounds = true
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc func languageChanged() {
        // Reassign icons and titles if language changes
        homeVc.tabBarItem = UITabBarItem(
            title: "Home".localized,
            image: UIImage(named: "explore"),
            selectedImage: UIImage(named: "explore_selected")
        )
        profileVc.tabBarItem = UITabBarItem(
            title: "Profile".localized,
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profile_selected")
        )
        
        self.instance.updateSemanticContentAttribute()
        
        // Rebuild Explore tab if needed
        if let index = viewControllers?.firstIndex(of: exploreNav ?? UINavigationController()) {
            exploreNav = createExploreTab()
            viewControllers?[safe: index] = exploreNav
        }
    }
    
    func showCartView() {
        guard let tabBarSuperview = tabBar.superview else { return }
        tabBarSuperview.insertSubview(self.instance.viewCardView, belowSubview: tabBar)
        self.instance.attach()
        self.view.bringSubviewToFront(tabBar)
    }
    
    @objc private func reloadCart() {
        self.cartViewModel.fetchCarts()
    }
    
    private func createHomeTab() -> UINavigationController {
        // Home tab uses Explore icons
        homeVc.tabBarItem = UITabBarItem(
            title: "Home".localized,
            image: UIImage(named: "explore"),
            selectedImage: UIImage(named: "explore_selected")
        )
        let homeNav = UINavigationController(rootViewController: homeVc)
        homeNav.setNavigationBarHidden(true, animated: false)
        homeNav.delegate = self
        return homeNav
    }
    
    private func createExploreTab() -> UINavigationController {
        // Explore tab uses Home icons
        explore = ExploreViewController()
        explore!.tabBarItem = UITabBarItem(
            title: "Explore".localized,
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home_selected")
        )
        let exploreNav = UINavigationController(rootViewController: explore!)
        exploreNav.setNavigationBarHidden(true, animated: false)
        exploreNav.delegate = self
        
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: AppFont.shared.font(
                    family: .Inter,
                    fontWeight: .semibold,
                    size: 12
                )!
            ]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: AppFont.shared.font(
                    family: .Inter,
                    fontWeight: .semibold,
                    size: 12
                )!
            ]
            tabBarAppearance.backgroundColor = .accent
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        return exploreNav
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if ViewCartFloatingView.cartItem != nil {
            if viewController == navigationController.viewControllers.first {
                self.cartViewState = .visible
            } else {
                self.cartViewState = .hidden
            }
        }
    }
    
    private func adjustFloatingViewVisibility(isVisible: Bool, animated: Bool) {
        if isVisible {
            self.showCartView()
        } else {
            self.instance.detach()
            UIView.animate(withDuration: animated ? 0.3 : 0) {
                self.instance.viewCardView.alpha = 0
            }
        }
    }
}
//dan
