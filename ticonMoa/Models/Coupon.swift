//
//  Gifticon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

struct Coupon: Equatable {

    var name: String
    var expiredDate: Date
    var brand: String
    var barcode: String
    var imageName: String { barcode }
    var image: UIImage?
    var category: String
    var isUsed: Bool
    var registerDate: Date
    var checked = false
    
    init(coupon: ManagedCoupon) {
        name = coupon.name
        barcode = coupon.barcode
        brand = coupon.brand
        expiredDate = coupon.expiredDate
        category = coupon.category
        isUsed = coupon.isUsed
        registerDate = coupon.registerDate
    }
    
    init(name: String, barcode: String, brand: String, date: Date, category: String, used: Bool = false, registerDate: Date) {
        self.name = name
        self.barcode = barcode
        self.brand = brand
        self.category = category
        self.expiredDate = date
        self.image = nil
        self.isUsed = used
        self.registerDate = registerDate
    }
    
    static func == (lhs: Coupon, rhs: Coupon) -> Bool {
        return lhs.barcode == rhs.barcode
    }
}
