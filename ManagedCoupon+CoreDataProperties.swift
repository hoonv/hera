//
//  ManagedCoupon+CoreDataProperties.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedCoupon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCoupon> {
        return NSFetchRequest<ManagedCoupon>(entityName: "ManagedCoupon")
    }

    @NSManaged public var barcode: String
    @NSManaged public var brand: String
    @NSManaged public var category: String
    @NSManaged public var expiredDate: Date
    @NSManaged public var name: String

}

extension ManagedCoupon : Identifiable {

}
