//
//  CouponListPresenter.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright (c) 2021  . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CouponListPresentationLogic {
    func presentCoupons(response: CouponList.FetchCoupon.Response)
}

class CouponListPresenter: CouponListPresentationLogic {
    weak var viewController: CouponListDisplayLogic?
    
    let manager = ImageManager()

    // MARK: Do something
    
    func presentCoupons(response: CouponList.FetchCoupon.Response) {
        let displayed = response.coupons.map { c -> CouponList.DisplayedCoupon in
            return convertToViewModel(coupon: c)
        }
        let filtered = applyFilter(coupons: displayed)
        let names = filtered.count > 1 ? ["사용전", "사용완료"] : ["사용전"]
        let viewModel = CouponList.FetchCoupon.ViewModel(sectionName: names, coupons: filtered)
        viewController?.displayCouponList(viewModel: viewModel)
    }
    
    func applyFilter(coupons: [CouponList.DisplayedCoupon]) ->
    [[CouponList.DisplayedCoupon]] {
        let order = UserDefaults.standard.integer(forKey: FilterOption.order.rawValue)
        let isShowExpired = UserDefaults.standard.integer(forKey: FilterOption.expired.rawValue)
        var unusedCoupon = coupons.filter { !$0.isUsed }
        var usedCoupon = coupons.filter { $0.isUsed }
        if isShowExpired == 1 {
            unusedCoupon = unusedCoupon.filter { $0.remainDay >= 0 }
        }
        if order == 1 {
            unusedCoupon = unusedCoupon.sorted { $0.remainDay < $1.remainDay }
            usedCoupon = usedCoupon.sorted { $0.remainDay < $1.remainDay }
        }
        return usedCoupon.count > 0 ? [unusedCoupon, usedCoupon] : [unusedCoupon]
    }
    
    func convertToViewModel(coupon: Coupon) -> CouponList.DisplayedCoupon {
        let dateString = coupon.expiredDate.toStringKST(dateFormat: "yyyy.MM.dd") + "까지"
        let image = manager.loadImageFromDiskWith(fileName: coupon.barcode)
        let remainDay = calcuateRemainDays(coupon.expiredDate)
        let remainString = remainDay < 0 ? "기간만료" : "D-\(remainDay)"
        let color = defineTagColor(coupon.expiredDate)
        return CouponList.DisplayedCoupon(name: coupon.name,
                                          brand: coupon.brand,
                                          expiredDate: coupon.expiredDate,
                                          dateString: dateString,
                                          registerDate: coupon.registerDate,
                                          isUsed: coupon.isUsed,
                                          remainDay: remainDay,
                                          remainDayString: remainString,
                                          image: image,
                                          tagColor: color,
                                          barcode: coupon.barcode)
    }
    
    func calcuateRemainDays(_ date: Date) -> Int {
        return Int(ceil(date.timeIntervalSince(Date()) / (24 * 60 * 60)))
    }
    
    func defineTagColor(_ date: Date) -> UIColor {
        let remain = Int(ceil(date.timeIntervalSince(Date()) / (24 * 60 * 60)))
        if remain < 0 { return .gray}
        return UIColor(named: "appColor") ?? .orange
    }
}
