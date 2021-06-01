//
//  AutoPhotoVC + Setup.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/06/01.
//

import UIKit
import RxSwift

extension AutoPhotoViewController {
    
    func setupUI() {
        inputForm.delegate = self
        trashButton.layer.cornerRadius = 10
        checkButton.layer.cornerRadius = 10
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        let categories = horizontalScrollView.names.dropFirst().map { String($0) }
        horizontalScrollView.setCategory(categories: categories)
        photoManager.requestAuthorization()
    }
    
    func binding() {
        let barcodes: [String] = CoreDataManager.shared.fetchAll()
            .map { (c: Gifticon) -> String in
            c.barcode }
        photoManager.imageOutput
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { image in
                let barcodeDetector = BarcodeRequestWrapper(image: image) { [weak self] uiimage, payload  in
                    guard let self = self else { return }
                    if barcodes.contains(payload) {
                        return
                    }
                    self.imageBarcode.onNext((image, payload))
                }
                barcodeDetector.perform()
            })
            .disposed(by: bag)
        
        imageBarcode
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image, barcode in
                let ocr = OCRManager()
                let payloads: [[String]] = ocr.requestTextRecognition(image: image)

                let b = self.recognizeBrand(input: payloads) ?? ""
                let d = self.recognizeDate(input: payloads) ?? Date(timeIntervalSince1970: 0)
                let n = self.recognizeName(input: payloads) ?? ""
                var g = Gifticon(name: n,
                                 barcode: barcode,
                                 brand: b,
                                 date: d,
                                 category: self.horizontalScrollView.names[0])
                g.image = image
                if self.gificons.count == 0 {
                    self.inputForm.configure(g)
                    self.imageView.image = g.image
                }
                self.gificons.append(g)
                self.collectionView.reloadData()
            })
            .disposed(by: bag)
    }
    
    private func recognizeName(input: [[String]]) -> String? {
        let nameReg = NameRecognizer()
        for (idx, line) in input.enumerated() {
            let joined = line.joined()
            let n1 = input[safe: idx - 2]?.first
            let n2 = input[safe: idx - 1]?.first
            if let name = nameReg.match(input: joined, candidates: [n1,n2]) {
                return name
            }
        }
        return nil
    }
    
    private func recognizeDate(input: [[String]]) -> Date? {
        let dateReg = DateRecognizer()
        for line in input {
            for word in line {
                if let date = dateReg.match(input: word) {
                    return date
                }
            }
        }
        return nil
    }
    
    private func recognizeBrand(input: [[String]]) -> String? {
        let brandReg = BrandRecognizer()
        for line in input {
            for word in line {
                if let brand = brandReg.match(input: word) {
                    return brand
                }
            }
        }
        return nil
    }
}
