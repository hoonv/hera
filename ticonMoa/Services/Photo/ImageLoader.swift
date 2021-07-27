//
//  ImageLoader.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/26.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit
import Photos

class ImageLoader {
    
    private var loadedImages = [PHAsset: UIImage]()
    private var runningRequests = [PHAsset: PHImageRequestID]()
    
    public static let shared: ImageLoader = ImageLoader()
    
    private init() {
        
    }
    
    var imageSize = CGSize(width: 300, height: 300)
    var requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        return option
    }()

    func loadImageHighQuality(_ asset: PHAsset, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imgSize = CGSize(width: 1200, height: 1200)
        
        if let image = loadedImages[asset],
           image.size.height > 300 && image.size.width > 300  {
            completion(.success(image))
            return
        }
        let id = PHImageManager.default().requestImage(for: asset, targetSize: imgSize, contentMode: .aspectFit, options: nil) { image, _ in

            defer { self.runningRequests.removeValue(forKey: asset) }
            
            guard let img = image else { return }
            if img.size.width > 300 && img.size.height > 300 {
                self.loadedImages[asset] = img
            }
            completion(.success(img))
        }

        runningRequests[asset] = id
    }
    
    func loadImage(_ asset: PHAsset, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = loadedImages[asset] {
            completion(.success(image))
            return
        }
        
        let id = PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: nil) { image, _ in

            defer { self.runningRequests.removeValue(forKey: asset) }
            
            guard let img = image else { return }
            self.loadedImages[asset] = img
            completion(.success(img))
        }

        runningRequests[asset] = id
        
    }

    func cancelLoad(_ asset: PHAsset) {
        guard let id = runningRequests[asset] else { return }
        PHImageManager.default().cancelImageRequest(id)
        runningRequests.removeValue(forKey: asset)
    }
}
