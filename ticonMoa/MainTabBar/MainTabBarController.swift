//
//  UITabBarController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/30.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let floatingTabbarView = RoundTabBarView(["house", "magnifyingglass", "person"])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupFloatingTabBar()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        guard let homeVC: HomeViewController = UIStoryboard.main.instantiate(),
              let searchVC: SearchViewController = UIStoryboard.main.instantiate() ,
              let profileVC: ProfileViewController = UIStoryboard.main.instantiate()
        else { return }
        self.viewControllers = [homeVC, searchVC, profileVC]
    }

    private func setupFloatingTabBar() {
        floatingTabbarView.delegate = self
        view.addSubview(floatingTabbarView)
        floatingTabbarView.centerXInSuperview()
        floatingTabbarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}

extension MainTabBarController: RoundTabBarViewDelegate {
    func roundTabBarView(_ roundTabBarView: RoundTabBarView, didSelected index: Int) {
        self.selectedIndex = index
    }
    
}
