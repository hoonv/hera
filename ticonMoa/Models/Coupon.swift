//
//  Gifticon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

struct Coupon: Equatable {

    var identifier: UUID
    var isUsed: Bool
    var name: String
    var brand: String
    var barcode: String
    var category: String
    var expiredDate: Date
    var registerDate: Date
    var image: UIImage?

    init(coupon: ManagedCoupon) {
        identifier = coupon.identifier
        name = coupon.name
        barcode = coupon.barcode
        brand = coupon.brand
        expiredDate = coupon.expiredDate
        category = coupon.category
        isUsed = coupon.isUsed
        registerDate = coupon.registerDate
    }
    
    init(id: UUID, name: String, barcode: String, brand: String, date: Date, category: String, used: Bool = false, registerDate: Date) {
        self.identifier = id
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
        return lhs.identifier == rhs.identifier
    }
}
