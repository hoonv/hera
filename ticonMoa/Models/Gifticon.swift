//
//  Gifticon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

struct Gifticon: Equatable {

    var name: String
    var expiredDate: Date
    var brand: String
    var barcode: String
    var imageName: String { barcode }
    var image: UIImage?
    var category: String
    var checked = false
    
    init(coupon: Coupon) {
        name = coupon.name
        barcode = coupon.barcode
        brand = coupon.brand
        expiredDate = coupon.expiredDate
        category = coupon.category
    }
    
    init(name: String, barcode: String, brand: String, date: Date, category: String) {
        self.name = name
        self.barcode = barcode
        self.brand = brand
        self.category = category
        self.expiredDate = date
        image = nil
    }
    
    static func == (lhs: Gifticon, rhs: Gifticon) -> Bool {
        return lhs.barcode == rhs.barcode
    }
}
