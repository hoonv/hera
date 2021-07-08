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
    
    func configure(name: String, barcode: String, brand: String, expired: Date, category: String) {
        self.name = name
        self.brand = brand
        self.barcode = barcode
        self.expiredDate = expired
        self.category = category
    }
    
    func configure(gifticon: Gifticon) {
        self.name = gifticon.name
        self.brand = gifticon.brand
        self.barcode = gifticon.barcode
        self.expiredDate = gifticon.expiredDate
        self.category = gifticon.category

    }
}
