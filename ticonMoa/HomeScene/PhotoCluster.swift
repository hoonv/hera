//
//  PhotoCluster.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/27.
//

import UIKit
import Photos

class PhotoCluster {
    
    private let displayWidth = UIScreen.main.bounds.width
    private let displayHeight = UIScreen.main.bounds.height

    private let timeDiffer = 30
    
    let data: [PHAsset]
    
    init(data: [PHAsset]) {
        self.data = data
    }
    
    func isCapturedPhoto(rect: CGRect) -> Bool {
        let widthRemainder = rect.width.truncatingRemainder(dividingBy: displayWidth)
        let heightRemainder = rect.height.truncatingRemainder(dividingBy: displayHeight)
        return widthRemainder == 0 && heightRemainder == 0
    }
    
    func execute() {
        for i in data {
            print(i.pixelWidth, i.pixelHeight, i.creationDate!)
        }
    }
}
