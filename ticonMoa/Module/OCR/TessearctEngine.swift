//
//  OCREngine.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/10.
//

import UIKit
import SwiftyTesseract

protocol OCREngineType {
    typealias Payload = String
    func recognition(image: UIImage) -> [[Payload]]
    func recognition(image: UIImage) -> [Payload]
}

class TessearctEngine: OCREngineType {
    
    let engine: Tesseract
    
    init() {
        engine = Tesseract(languages: [.english, .korean]) {
            set(.disallowlist, value: "•@#$%^&*")
            set(.preserveInterwordSpaces, value: .true)
        }
    }
    
    func recognition(image: UIImage) -> [[Payload]] {
        let ret: [Payload] = recognition(image: image)
        return ret.map {
            $0.split(separator: " ")
                .map { String($0) }}
    }
    
    func recognition(image: UIImage) -> [Payload] {
        let res = engine.performOCR(on: image)
        switch res {
        case .success(let input):
            let toks = input
                .split(separator: "\n")
                .map { String($0) }
            return toks
        default:
            return []
        }
    }
}
