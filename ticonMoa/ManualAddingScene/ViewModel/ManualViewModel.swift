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
}

protocol ManualViewModelType {
    var input: ManualViewModelInput { get }
    var output: ManualViewModelOutput { get }
}

class ManualViewModel: ManualViewModelInput, ManualViewModelOutput, ManualViewModelType {

    var input: ManualViewModelInput { self }
    var output: ManualViewModelOutput { self }
    
    private var ocr: G8Tesseract?

    init(ocr: G8Tesseract?) {
        self.ocr = ocr
    }
    
    
    func requestTextRecognition(image: UIImage, layer: CALayer) {
        let brw = BarcodeRequestWrapper(image: image, completion: { _ in })
        //barcode image 와 숫자 바인딩
        brw.requestDetection()
        
        let trw = TextRecognitionWrapper(image: image, layer: layer, completion: { image in
            let ret = self.recognizeWithTesseract(image: image)
            DispatchQueue.main.async {
//                self.textView.text = self.textView.text + ret
            }
        })
        DispatchQueue.global().async {
            trw.perform()
        }
    }
    
    func recognizeWithTesseract(image: UIImage) -> String {
        ocr?.image = image
        ocr?.recognize()
        return ocr?.recognizedText ?? ""
    }
}
