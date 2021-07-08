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
    func fetchAllGifticon()
    func changeCategory(gifticons: [[Coupon]], category: String)
}

protocol HomeViewModelOutput {
    var images: BehaviorSubject<[UIImage]> { get }
    var isProccess: BehaviorSubject<Bool> { get }
    var gificons: PublishSubject<[[Coupon]]> { get }
    var filteredGificons: PublishSubject<[[Coupon]]> { get }
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
    var gificons = PublishSubject<[[Coupon]]>()
    var filteredGificons =  PublishSubject<[[Coupon]]>()

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
    
    func fetchAllGifticon() {
        var gifty: [Coupon] = CoreDataManager.shared
            .fetchAll()
            .sorted { a, b in
            a.expiredDate < b.expiredDate
        }
        let im = ImageManager()
        for i in 0..<gifty.count {
            gifty[i].image =         im.loadImageFromDiskWith(fileName: gifty[i].imageName)

        }
        var groupedGifticon: [[Coupon]] = [[]]
        let gifticonbyBrand = Dictionary(grouping: gifty, by: { $0.brand })
        
        for (_, value) in gifticonbyBrand {
            groupedGifticon.append(value)
        }
        gificons.onNext(groupedGifticon)
    }

    func requestPhotoWithAuto() {
        isProccess.on(.next(true))
        photoManager.requestAuthorization()
    }
    func changeCategory(gifticons: [[Coupon]], category: String) {
        if category == "box" {
            filteredGificons.onNext(gifticons)
            return
        }
        let gifty = gifticons.joined().filter { $0.category == category }
        
        var groupedGifticon: [[Coupon]] = [[]]
        let gifticonbyBrand = Dictionary(grouping: gifty, by: { $0.brand })
        
        for (_, value) in gifticonbyBrand {
            groupedGifticon.append(value)
        }
        filteredGificons.onNext(groupedGifticon)
    }

}
