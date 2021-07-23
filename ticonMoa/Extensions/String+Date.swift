//
//  String + Date.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/21.
//  Copyright © 2021 hoon. All rights reserved.
//

import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)
    }
}
