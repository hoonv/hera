//
//  DisplayedCoupon.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/27.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

struct ViewModelCoupon: Equatable {
    let id: UUID
    let name: String
    let brand: String
    let barcode: String
    let expiredDate: Date
    let registerDate: Date
    let isUsed: Bool
    let image: UIImage?
    let remainDay: Int
    let remainDayString: String
    let tagColor: UIColor
    let dateString: String

    static let empty = ViewModelCoupon()
    
    private init() {
        id =  UUID()
        name =  String()
        brand =  String()
        barcode =  String()
        expiredDate =  Date()
        registerDate =  Date()
        isUsed =  false
        image = nil
        remainDay =  Int()
        remainDayString =  String()
        tagColor =  UIColor.blue
        dateString =  String()
    }
    
    init(coupon: Coupon) {
        self.id = coupon.identifier
        self.name = coupon.name
        self.brand = coupon.brand
        self.barcode = coupon.barcode
        self.expiredDate = coupon.expiredDate
        self.registerDate = coupon.registerDate
        self.isUsed = coupon.isUsed
        self.image = coupon.image
        self.remainDay = ViewModelCoupon.calcuateRemainDays(coupon.expiredDate)
        self.remainDayString = remainDay < 0 ? "기간만료" : "D-\(remainDay)"
        self.tagColor = ViewModelCoupon.defineTagColor(coupon.expiredDate)
        self.dateString = coupon.expiredDate.toStringKST(dateFormat: "yyyy.MM.dd") + "까지"
    }
    
    static func calcuateRemainDays(_ date: Date) -> Int {
        return Int(ceil(date.timeIntervalSince(Date()) / (24 * 60 * 60)))
    }
    
    static func defineTagColor(_ date: Date) -> UIColor {
        let remain = Int(ceil(date.timeIntervalSince(Date()) / (24 * 60 * 60)))
        if remain < 0 { return .gray}
        return UIColor(named: "appColor") ?? .orange
    }
}
