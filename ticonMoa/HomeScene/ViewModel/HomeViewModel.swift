//
//  HomeViewModel.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit
import RxSwift

protocol HomeViewModelInput {
    func requestPhotoWithAuto()
}

protocol HomeViewModelOutput {
    var images: BehaviorSubject<[UIImage]> { get }
    var isFinished: BehaviorSubject<Bool> { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelInput, HomeViewModelOutput, HomeViewModelType {
    
    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }
    
    var images = BehaviorSubject<[UIImage]>(value: [])
    var isFinished = BehaviorSubject<Bool>(value: false)
    
    private var _images: [UIImage] = []
    private let photoManager = PhotoManager()

    init() {
        photoManager.delegate = self
    }

    func requestPhotoWithAuto() {
        isFinished.on(.next(true))
        photoManager.requestAuthAndGetAllPhotos()
    }
    
}


extension HomeViewModel: PhotoManagerDelegate {
    func photoManager(_ photoManager: PhotoManager, didLoad image: UIImage?, index: Int, isLast: Bool) {
        guard let image = image else { return }

        if isLast {
            self.isFinished.on(.next(false))
        }
        
        let barcodeWrapper: BarcodeRequestWrapper? = BarcodeRequestWrapper(image: image) { [weak self] uiimage in
            guard let self = self else { return }
            self._images.append(image)
            self.images.on(.next(self._images))
        }
        barcodeWrapper?.requestDetection()
    }
}
