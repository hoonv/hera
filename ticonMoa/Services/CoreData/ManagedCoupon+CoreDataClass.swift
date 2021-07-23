//
//  ManagedCoupon+CoreDataClass.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCoupon)
public class ManagedCoupon: NSManagedObject {
    
    func configure(name: String, barcode: String, brand: String, expired: Date, category: String, isUsed: Bool, register: Date) {
        self.name = name
        self.brand = brand
        self.barcode = barcode
        self.expiredDate = expired
        self.category = category
        self.isUsed = isUsed
        self.registerDate = register
    }
    
    func configure(coupon: Coupon) {
        self.name = coupon.name
        self.brand = coupon.brand
        self.barcode = coupon.barcode
        self.expiredDate = coupon.expiredDate
        self.category = coupon.category
        self.isUsed = coupon.isUsed
        self.registerDate = coupon.registerDate 
    }
}
