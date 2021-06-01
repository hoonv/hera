//
//  PhotoManager.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/25.
//

import UIKit
import Photos
import RxSwift

final class PhotoManager {

    let imageOutput = PublishSubject<UIImage>()
    let isProccess = PublishSubject<Bool>()
    let bag = DisposeBag()
    
    func requestAuthorization() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: requestAuthHandler)
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthHandler)
        }
    }
    
    private func requestAuthHandler(status: PHAuthorizationStatus) {
        switch status {
        case .denied, .notDetermined, .restricted:
            print("사진 권한이 필요합니다")
        case .limited, .authorized:
            requestPhotos()
        @unknown default:
            break
        }
    }
    
    // PhotoLibray에 요청하는 옵션
    private var fetchOptions: PHFetchOptions = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
//        options.fetchLimit = 1000
        let end = formatter.string(from: Date(timeIntervalSinceNow: -180*24*60*60))
        let today = formatter.string(from: Date(timeIntervalSinceNow: 24*60*60))
        if let startDate = formatter.date(from: end),
           let endDate = formatter.date(from: today) {
            options.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as NSDate, endDate as NSDate)
        }
        return options
    }()
    
    // fetchResult -> Image로 변환할때 필요한 옵션
    var requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        return option
    }()
    var targetSize = CGSize(width: 500, height: 800)
    var contentMode: PHImageContentMode = .aspectFit
     
    private func requestPhotos() {
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.fetchOptions)
        
        let assets = fetchResult.objects(at:
                                IndexSet(integersIn: 0..<fetchResult.count))
        let aa: [PHAsset] = PhotoCluster(data: assets).execute()
        print(assets.count, aa.count)
        PhotoCluster(data: assets).execute()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { asset in
            PHImageManager.default()
                .requestImage(for: asset,
                              targetSize: self.targetSize,
                              contentMode: self.contentMode,
                              options: self.requestOptions,
                              resultHandler: { image, _ in
                guard let image = image else { return }
                self.imageOutput.on(.next(image))
            })
            }, onCompleted: { self.isProccess.on(.next(false)) })
        .disposed(by: bag)
    }
}
