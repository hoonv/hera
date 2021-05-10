//
//  Gifticon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import Foundation

struct Gifticon {
    let name: String
    let expiredDate: Date
    let brand: String
    let barcode: String
    let category: Category
}

struct Category {
    let name: String
    let imageName: String
}
