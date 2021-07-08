//
//  UITabBarController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/30.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let floatingTabbarView = RoundTabBarView(["house", "plus.square","magnifyingglass", "person"])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupFloatingTabBar()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let homeVC = CouponListViewController()
        let searchVC = CouponListViewController()
        let profileVC =  CouponListViewController()
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
