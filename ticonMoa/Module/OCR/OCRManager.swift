//
//  OCRManager.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/10.
//

import UIKit

protocol OCRManagerType {
    
    typealias Payload = String
    
    var ocrEngine: OCREngineType { get }
    
    func requestBarcodeRecognition(image: UIImage, completion:  @escaping (UIImage, Payload) -> ())
    
    func requestTextRecognition(image: UIImage) -> [Payload]
    func requestTextRecognition(image: UIImage) -> [[Payload]]

    func requestTextRecognition(engine: OCREngineType, image: UIImage) -> [Payload]
}

class OCRManager: OCRManagerType {

    var ocrEngine: OCREngineType
    
    init() {
        ocrEngine = TessearctEngine()
    }
    
    func requestTextRecognition(image: UIImage) -> [Payload] {
        return ocrEngine.recognition(image: image)
    }
    
    func requestTextRecognition(engine: OCREngineType, image: UIImage) -> [Payload] {
        return engine.recognition(image: image)
    }
    
    func requestTextRecognition(image: UIImage) -> [[Payload]] {
        return ocrEngine.recognition(image: image)
    }
    
    func requestBarcodeRecognition(image: UIImage, completion: @escaping (UIImage, Payload) -> ()) {
        let brw = BarcodeRequestWrapper(image: image, completion: completion)
        brw.perform()
    }
}
