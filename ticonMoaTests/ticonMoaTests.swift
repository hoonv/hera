//
//  ticonMoaTests.swift
//  ticonMoaTests
//
//  Created by 채훈기 on 2021/04/27.
//

import XCTest

class ticonMoaDateTests: XCTestCase {


    func testTimeDiffer() {
        let after10 = Date(timeIntervalSince1970: 10)
        let after20 = Date(timeIntervalSince1970: 20)
        let d = after20.timeIntervalSince(after10)
        XCTAssertEqual(d, 10)
    }
    
    func testCreateDate() {
        let dr = DateRecognizer()
        let input = "2020.02.01"
        guard let date = dr.recognize(input: input) else {
            XCTAssert(false)
            return
        }
        let dateString = date.toStringKST(dateFormat: "yyyy.MM.dd")
        XCTAssertEqual(dateString, input)
    }
}


