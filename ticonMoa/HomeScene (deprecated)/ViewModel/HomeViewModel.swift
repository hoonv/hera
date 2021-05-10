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
    var isProccess: BehaviorSubject<Bool> { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelInput, HomeViewModelOutput, HomeViewModelType {
    
    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }
    
    var images = BehaviorSubject<[UIImage]>(value: [])
    var isProccess = BehaviorSubject<Bool>(value: false)
    
    private var _images: [UIImage] = []
    private let photoManager = PhotoManager()

    let bag = DisposeBag()
    
    init() {
        photoManager.isProccess
            .subscribe(onNext: { flag in
                self.isProccess.onNext(flag)
            })
            .disposed(by: bag)
        photoManager.imageOutput
            .subscribe(onNext: { image in
                let barcodeDetector = BarcodeRequestWrapper(image: image) { [weak self] uiimage, payload  in
                    guard let self = self else { return }
                    self._images.append(image)
                    self.images.on(.next(self._images))
                }
                barcodeDetector.perform()
            })
            .disposed(by: bag)
    }

    func requestPhotoWithAuto() {
        isProccess.on(.next(true))
        photoManager.requestAuthorization()
    }
    
}
