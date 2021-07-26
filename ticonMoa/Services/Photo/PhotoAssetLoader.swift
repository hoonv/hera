//
//  PhotoAssetLoader.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/26.
//  Copyright © 2021 hoon. All rights reserved.
//

import Photos
import Foundation

class PhotoAssetLoader {
    
    private var fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        return options
    }()
    var requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        return option
    }()
    var targetSize = CGSize(width: 500, height: 800)
    var contentMode: PHImageContentMode = .aspectFit
    
    
    func loadAssets() -> [PHAsset] {
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.fetchOptions)
        let assets = fetchResult.objects(at:
                                IndexSet(integersIn: 0..<fetchResult.count))
        return assets
    }
}
