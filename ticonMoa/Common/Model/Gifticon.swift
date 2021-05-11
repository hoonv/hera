//
//  Gifticon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import Foundation

struct Gifticon: Equatable {

    let name: String
    let expiredDate: Date
    let brand: String
    let barcode: String
    let category: Category?
    
    init(coupon: Coupon) {
        self.name = coupon.name
        self.barcode = coupon.brand
        self.brand = coupon.brand
        self.expiredDate = coupon.expiredDate
        category = nil
    }
    
    init(name: String, barcode: String, brand: String, date: Date) {
        self.name = name
        self.barcode = brand
        self.brand = brand
        self.expiredDate = date
        category = nil
    }
    
    static func == (lhs: Gifticon, rhs: Gifticon) -> Bool {
        return lhs.barcode == rhs.barcode
    }
}
