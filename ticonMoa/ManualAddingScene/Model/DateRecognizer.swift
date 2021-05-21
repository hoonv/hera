//
//  DateRecognizer.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/28.
//

import Foundation

class DateRecognizer {
    
    let formatter = DateFormatter()
    let formatts: [String]
    
    init(formatts: [String] = ["yyyy.MM.dd", "yyyy-MM-dd"]) {
        self.formatts = formatts
    }
    
    func match(input: String) -> Date? {
        for format in formatts {
            formatter.dateFormat = format
            if let date = formatter.date(from: input) {
                return date
            }
        }
        return nil
    }
}
