//
//  TiconTabBarController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/09/02.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit


class TiconTabBarController: UITabBarController {
    
    private let floatingTabbarView: TiconTabView = {
        let view = TiconTabView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        setupFloatingTabBar()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let listVC = CouponListViewController()
        let searchVC: UINavigationController = {
            let nav = UINavigationController()
            nav.viewControllers = [SearchViewController()]
            nav.navigationBar.isHidden = true
            return nav
        }()
        let profileVC =  ProfileViewController()
        self.viewControllers = [listVC, searchVC, profileVC]
    }

    private func setupFloatingTabBar() {
        view.addSubview(floatingTabbarView)
        floatingTabbarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
