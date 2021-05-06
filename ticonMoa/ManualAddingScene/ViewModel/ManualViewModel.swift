//
//  ManualViewModel.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit
import RxSwift

import SwiftyTesseract

protocol ManualViewModelInput {
    func requestTextRecognition(image: UIImage, layer: CALayer)
}

protocol ManualViewModelOutput {
    var barcode: BehaviorSubject<String> { get }
    var name: BehaviorSubject<String> { get }
    var brand: BehaviorSubject<String> { get }
    var expirationDate: BehaviorSubject<Date> { get }
}

protocol ManualViewModelType {
    var input: ManualViewModelInput { get }
    var output: ManualViewModelOutput { get }
}

class ManualViewModel: ManualViewModelInput, ManualViewModelOutput, ManualViewModelType {

    var input: ManualViewModelInput { self }
    var output: ManualViewModelOutput { self }

    var barcode = BehaviorSubject<String>(value: "")
    var name = BehaviorSubject<String>(value: "")
    var brand = BehaviorSubject<String>(value: "")
    var expirationDate = BehaviorSubject<Date>(value: Date())

    let tesseract = Tesseract(languages: [.english, .korean]) {
        set(.disallowlist, value: "•@#$%^&*")
        set(.preserveInterwordSpaces, value: .true)
    }

    init() {

    }
    
    func requestTextRecognition(image: UIImage, layer: CALayer) {
            
        let barcodeRequest = BarcodeRequestWrapper(image: image, completion: barcodeRequestHandler)

        barcodeRequest.perform()
        
        let res = tesseract.performOCR(on: image)
        switch res {
        case .success(let input):
            let toks = input
                .split(separator: "\n")
                .map { $0.split(separator: " ").map { String($0) }
                }
            analyzeOCRResult(input: toks)
        default:
            print("ocr ERROR in Manual View Model")
        }
   
    }
    
    func analyzeOCRResult(input: [[String]]) {
        let dateReg = DateRecognizer()
        let brandReg = BrandRecognizer()
        
        for (idx, line) in input.enumerated() {
            
            let joined = line.joined()
            if joined.count >= 12 && Int(joined) != nil {
                guard let n1 = input[idx - 2].first,
                      let n2 = input[idx - 1].first else { continue }
                if n1.count > n2.count {
                    self.name.on(.next(n1))
                } else {
                    self.name.on(.next(n2))
                }
            }
            
            for word in line {
                if let date = dateReg.recognize(input: word) {
                    self.expirationDate.on(.next(date))
                    continue
                }
                if let brand = brandReg.match(input: word) {
                    self.brand.on(.next(brand))
                    continue
                }
            }
        }
        
    }
    
    func barcodeRequestHandler(image: UIImage, payload: String) {
        self.barcode.on(.next(payload))
    }
    
    func textRequestHandler(data: [(UIImage, String)]) {
        
        for (_, payload) in data {
            let dateReg = DateRecognizer()
            let brandReg = BrandRecognizer()
            if let date = dateReg.recognize(input: payload) {
                self.expirationDate.on(.next(date))
                continue
            }
            
            if let brand = brandReg.match(input: payload) {
                self.brand.on(.next(brand))
                continue
            }
        }
    }
}
