//
//  PhotoCluster.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit
import Photos
import RxSwift

class PhotoCluster {
    
    private let displayWidth = UIScreen.main.bounds.width
    private let displayHeight = UIScreen.main.bounds.height

    private let timeDiffer: TimeInterval = 30 // seconds
    
    let data: [PHAsset]
    
    init(data: [PHAsset]) {
        self.data = data
    }
    
    func isCapturedPhoto(size: CGSize) -> Bool {
        let widthRemainder = size.width.truncatingRemainder(dividingBy: displayWidth)
        let heightRemainder = size.height.truncatingRemainder(dividingBy: displayHeight)
        return widthRemainder == 0 && heightRemainder == 0
    }
    
    func execute() -> [PHAsset] {
        var assets: [PHAsset] = []
        var temporaryAssets: [PHAsset] = []
        
        for i in data {
            if isCapturedPhoto(size: i.size) {
                assets.append(i)
                continue
            }
            
            if temporaryAssets.isEmpty {
                temporaryAssets.append(i)
                continue
            }
            
            guard let lastAsset = temporaryAssets.last,
                  let prevDate = lastAsset.creationDate,
                  let currDate = i.creationDate
            else { continue }
        
            if lastAsset.size == i.size
                && currDate.timeIntervalSince(prevDate) < timeDiffer {
                temporaryAssets.append(i)
            } else {
                assets.append(temporaryAssets.first!)
                temporaryAssets.removeAll()
                temporaryAssets.append(i)
            }
        }
        
        if let first = temporaryAssets.first {
            assets.append(first)
        }
        
        return assets
    }
    
    func execute() -> Observable<PHAsset> {
        var assets: [PHAsset] = []
        var temporaryAssets: [PHAsset] = []
        
        for i in data {
            if isCapturedPhoto(size: i.size) {
                assets.append(i)
                continue
            }
            
            if temporaryAssets.isEmpty {
                temporaryAssets.append(i)
                continue
            }
            
            guard let lastAsset = temporaryAssets.last,
                  let prevDate = lastAsset.creationDate,
                  let currDate = i.creationDate
            else { continue }
        
            if lastAsset.size == i.size
                && currDate.timeIntervalSince(prevDate) < timeDiffer {
                temporaryAssets.append(i)
            } else {
                assets.append(temporaryAssets.first!)
                temporaryAssets.removeAll()
                temporaryAssets.append(i)
            }
        }
        
        if let first = temporaryAssets.first {
            assets.append(first)
        }
        
        return Observable.create { observer in
            for asset in assets {
                observer.onNext(asset)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension PHAsset {
    var size: CGSize { CGSize(width: self.pixelWidth, height: self.pixelHeight)}
}
