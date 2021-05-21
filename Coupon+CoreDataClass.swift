//
//  Coupon+CoreDataClass.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/11.
//
//

import Foundation
import CoreData

@objc(Coupon)
public class Coupon: NSManagedObject {

    func configure(name: String, barcode: String, brand: String, expired: Date) {
        self.name = name
        self.brand = brand
        self.barcode = barcode
        self.expiredDate = expired
    }
    
    func configure(gifticon: Gifticon) {
        self.name = gifticon.name
        self.brand = gifticon.brand
        self.barcode = gifticon.barcode
        self.expiredDate = gifticon.expiredDate
    }
}
