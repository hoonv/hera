//
//  PhotoManager.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/25.
//

import UIKit
import Photos

final class PhotoManager {

    private let requiredAccessLevel: PHAccessLevel = .readWrite

    // PhotoLibray에 요청하는 옵션
    private let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        options.fetchLimit = 3
        // 최대 6개월의 사진 검색
        return options
    }()
    
    // fetchResult -> Image로 변환할때 필요한 옵션
    private let requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        return option
    }()
    private let targetSize = CGSize(width: 300, height: 500)
    private let contentMode: PHImageContentMode = .aspectFit
    
    
    func requestAuthorization(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { (status) in
            switch status {
            case .denied, .notDetermined:
                print("사진 권한 처리")
            case .limited, .authorized:
                completion()
            default:
                break
            }
        }
    }
    
    func requestAuthAndGetAllPhotos(completion: @escaping (UIImage?) -> Void ) {
        requestAuthorization {
            self.getCanAccessImages(completion: completion)
        }
    }
    
    private func getCanAccessImages(completion: @escaping (UIImage?) -> Void) {
  
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.fetchOptions)
        
        fetchResult.enumerateObjects { (asset, _, _ ) in
            PHImageManager.default().requestImage(for: asset, targetSize: self.targetSize,contentMode: self.contentMode, options: self.requestOptions) {
                (image, _) in
                completion(image)
            }
        }
    }
    
}
