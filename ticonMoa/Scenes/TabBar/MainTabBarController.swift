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
        let listVC = CouponListViewController()
        let addVC = CouponAddViewController()
        let profileVC =  CouponListViewController()
        self.viewControllers = [listVC, addVC, profileVC]
    }

    private func setupFloatingTabBar() {
        floatingTabbarView.delegate = self
        view.addSubview(floatingTabbarView)
        floatingTabbarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func hideTabBar() {
        floatingTabbarView.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.floatingTabbarView.alpha = 0
        }
    }
    
    func showTabBar() {
        floatingTabbarView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.floatingTabbarView.alpha = 1
        }
    }
}

extension MainTabBarController: RoundTabBarViewDelegate {
    func roundTabBarView(_ roundTabBarView: RoundTabBarView, didSelected index: Int) {
        self.selectedIndex = index
    }
    
}
