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
    let category: Category
    
    static func == (lhs: Gifticon, rhs: Gifticon) -> Bool {
        return lhs.barcode == rhs.barcode
    }
}
