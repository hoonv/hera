//
//  UITabBarController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/30.
//

import UIKit

class MainTabBarController: UITabBarController {

    let floatingTabbarView = RoundTabBarView(["house", "magnifyingglass", "person"])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupFloatingTabBar()
        
        self.viewControllers = []
    }

    func setupFloatingTabBar() {
        floatingTabbarView.delegate = self
        view.addSubview(floatingTabbarView)
        floatingTabbarView.centerXInSuperview()
        floatingTabbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}

extension MainTabBarController: RoundTabBarViewDelegate {
    func roundTabBarView(_ roundTabBarView: RoundTabBarView, didSelected index: Int) {
        self.selectedIndex = index
    }
    
}
