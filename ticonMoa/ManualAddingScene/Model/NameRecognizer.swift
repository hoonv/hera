//
//  NameRecognizer.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/10.
//

import Foundation

class NameRecognizer {
    
    func match(input: String, candidates: [String?]) -> String? {
        if candidates.contains(nil) || candidates.count < 2 {
            return nil
        }
        
        if input.count < 12 || Int(input) == nil {
            return nil
        }
        
        guard let n1 = candidates[0],
              let n2 = candidates[1] else { return nil }
        
        if n1.count > n2.count {
            return n1
        }
        
        return n2
    }
}
