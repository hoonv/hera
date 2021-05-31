//
//  Gifticon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

struct Gifticon: Equatable {

    let name: String
    let expiredDate: Date
    let brand: String
    let barcode: String
    let imageName: String
    var image: UIImage?
    let category: String
    
    init(coupon: Coupon) {
        name = coupon.name
        barcode = coupon.barcode
        brand = coupon.brand
        expiredDate = coupon.expiredDate
        imageName = coupon.barcode
        category = coupon.category
    }
    
    init(name: String, barcode: String, brand: String, date: Date, category: String) {
        self.name = name
        self.barcode = barcode
        self.brand = brand
        self.imageName = barcode
        self.category = category
        self.expiredDate = date
        image = nil
    }
    
    static func == (lhs: Gifticon, rhs: Gifticon) -> Bool {
        return lhs.barcode == rhs.barcode
    }
}
