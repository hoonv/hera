//
//  BrandRecognizer.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/28.
//

import Foundation

class BrandRecognizer {
    
    let brands = [
        "GS25": ["GS25", "gs25", "Gs25", "gS25"],
        "CU": ["CU", "cu", "Cu", "cU"],
        "스타벅스": ["starbucks", "스타벅스"],
        "공차": ["공자","공차"],
        "본죽": ["본죽","붓좆","목축","톱즉"],
        "bhc": ["bhc","BHC"],
        "도미노피자": ["도미노피자","도마노피자"],
    ]
    
    func match(input: String) -> String? {
        for (brand, candidates) in brands {
            if candidates.contains(input) { return brand } 
        }
        return nil
    }
}
