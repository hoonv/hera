//
//  CouponAddInteractor.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright (c) 2021 hoon. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Photos

protocol CouponAddBusinessLogic {
    func fetchPhotos(request: CouponAdd.fetchPhoto.Request)
    func changeSelectedImage(request: CouponAdd.fetchOnePhoto.Request)
    func fetchOnePhoto(request: CouponAdd.fetchOnePhoto.Request)
}

protocol CouponAddDataStore {
    var assets: [PHAsset] { get set }
    var images: [UIImage] { get set }
}

class CouponAddInteractor: CouponAddBusinessLogic, CouponAddDataStore {
    var presenter: CouponAddPresentationLogic?
    var worker: CouponAddWorker?
    var assets: [PHAsset] = []
    var images: [UIImage] = []
    var ocrManager = OCRManager()
    
    // MARK: fetchPhotos
    
    func fetchPhotos(request: CouponAdd.fetchPhoto.Request) {
        worker = CouponAddWorker() { [weak self] assets, images in
            self?.assets = assets
            self?.images = images
            self?.filterBarcore(images: images)
        }
        worker?.fetchPhotos()
    }
    
    func filterBarcore(images: [UIImage]) {
        var count = 0
        var tempImage: [UIImage] = []
        images.forEach {
            ocrManager.requestBarcodeRecognition(image: $0, completion: { image, payload in
                count += 1
                if let _ = payload {
                    tempImage.append(image)
                }
                if count == images.count {
                    self.images =  tempImage
                    let response = CouponAdd.fetchPhoto.Response(images: tempImage)
                    self.presenter?.presentFetchedPhoto(response: response)
                }
                
            })

        }
    }
    
    func fetchOnePhoto(request: CouponAdd.fetchOnePhoto.Request) {
        worker?.requestImage(asset: assets[request.index.row]) { [weak self] image in
            let response = CouponAdd.fetchOnePhoto.Response(index: request.index, image: image)
            self?.images[request.index.row] = image
            self?.presenter?.presentFetchOnePhoto(response: response)
        }
    }
    
    func changeSelectedImage(request: CouponAdd.fetchOnePhoto.Request) {
        let image = images[request.index.row]
        let imageSize = image.size
        if imageSize.width <= 360 && imageSize.height <= 360 {
            fetchOnePhoto(request: request)
        } else {
            let response = CouponAdd.fetchOnePhoto.Response(index: request.index, image: image)
            self.presenter?.presentFetchOnePhoto(response: response)
        }
    }
    
}
