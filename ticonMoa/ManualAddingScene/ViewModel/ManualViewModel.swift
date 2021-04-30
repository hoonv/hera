//
//  ManualViewModel.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit
import RxSwift
import TesseractOCR

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

    private var ocr: G8Tesseract?

    init(ocr: G8Tesseract?) {
        self.ocr = ocr
    }
    
    func requestTextRecognition(image: UIImage, layer: CALayer) {
        let barcodeRequest = BarcodeRequestWrapper(image: image, completion: barcodeRequestHandler)
        let textRequest = TextRecognitionWrapper(image: image, layer: layer, completion: textRequestHandler)
        
        textRequest.perform()
        barcodeRequest.perform()
    }
    
    func barcodeRequestHandler(image: UIImage, payload: String) {
        self.barcode.on(.next(payload))
    }
    
    func textRequestHandler(data: [(UIImage, String)]) {
        
        for (image, payload) in data {
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
            
            self.recognizeWithTesseract(image: image) { str in
                guard let str = str else { return }
                
                if let date = dateReg.recognize(input: str) {
                    self.expirationDate.on(.next(date))
                }
                if let brand = brandReg.match(input: str) {
                    self.brand.on(.next(brand))
                    return
                }
            }
            
        }
    }
    

    
    func recognizeWithTesseract(image: UIImage, completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            let oocr = G8Tesseract(language: "eng+kor")
            oocr?.image = image
            oocr?.recognize()
            let str = oocr?.recognizedText?.trimmingCharacters(in: .whitespacesAndNewlines)
            completion(str)
        }
    }
}
