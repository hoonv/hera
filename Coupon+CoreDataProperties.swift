//
//  Coupon+CoreDataProperties.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/11.
//
//

import Foundation
import CoreData


extension Coupon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coupon> {
        return NSFetchRequest<Coupon>(entityName: "Coupon")
    }

    @NSManaged public var name: String
    @NSManaged public var barcode: String
    @NSManaged public var expiredDate: Date
    @NSManaged public var brand: String
    @NSManaged public var category: String

}

extension Coupon : Identifiable {

}
