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
    func executeOCR(image: UIImage)
    func executeOCR(image: UIImage, layer: CALayer)
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

    let ocrManager: OCRManager
    
    init() {
        ocrManager = OCRManager()
    }
    
    func executeOCR(image: UIImage) {
        ocrManager.requestBarcodeRecognition(image: image, completion: barcodeRequestHandler)
        let payloads: [[String]] = ocrManager.requestTextRecognition(image: image)
        analyzeOCRResult(input: payloads)
    }
    
    func executeOCR(image: UIImage, layer: CALayer) {
        executeOCR(image: image)
    }
    
    private func analyzeOCRResult(input: [[String]]) {

        let nameReg = NameRecognizer()
        for (idx, line) in input.enumerated() {
            let joined = line.joined()
            let n1 = input[safe: idx - 2]?.first
            let n2 = input[safe: idx - 1]?.first
            if let name = nameReg.match(input: joined, candidates: [n1,n2]) {
                self.name.on(.next(name))
            }
            
            recognizeDateBrand(line: line)

        }
    }
    
    private func recognizeDateBrand(line: [String]) {
        let dateReg = DateRecognizer()
        let brandReg = BrandRecognizer()
        for word in line {
            if let date = dateReg.match(input: word) {
                self.expirationDate.on(.next(date))
                continue
            }
            if let brand = brandReg.match(input: word) {
                self.brand.on(.next(brand))
                continue
            }
        }
    }
    
    private func barcodeRequestHandler(image: UIImage, payload: String) {
        self.barcode.on(.next(payload))
    }
}
