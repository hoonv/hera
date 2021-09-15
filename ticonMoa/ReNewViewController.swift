//
//  ReNewViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/09/15.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit
import Photos

class ReNewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    private var requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        
        return option
    }()
    private var targetSize = CGSize(width: 600, height: 600)
    private var highTargetSize = CGSize(width: 900, height: 900)

    private var contentMode: PHImageContentMode = .aspectFit
    var images: [UIImage] = [] {
        didSet {
            print(images.count)
        }
    }
    var barcodes: [UIImage] = []
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(button1)
        view.addSubview(button2)
        
        let assets = PhotoAssetLoader().loadAssets().chunked(by: 500)
        print(assets.map { $0.count })
        
        for chunk in assets {
            DispatchQueue.global().async {
                let imageManager = PHImageManager()
                for asset in chunk {
                    imageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: self.contentMode, options: self.requestOptions, resultHandler: { a, b in
                        guard let image = a else { return }
                        self.images.append(image)
                    })
                }
            }
        }

        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-100)

        }
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        button1.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.trailing)
            make.top.equalTo(button)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        button2.snp.makeConstraints { make in
            make.trailing.equalTo(button.snp.leading)
            make.top.equalTo(button)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        button.addTarget(self, action: #selector(touchedButton), for: .touchDown)
        button1.addTarget(self, action: #selector(barcodeButton), for: .touchDown)
        button2.addTarget(self, action: #selector(barcodeRandom), for: .touchDown)


    }
    @objc func barcodeRandom() {
        imageView.image = barcodes.randomElement()
    }
    
    @objc func touchedButton() {
        imageView.image = images.randomElement()
    }
    
    @objc func barcodeButton() {
        print("touched")
        for image in images {
            BarcodeRequestWrapper(image: image, completion: {
                a, b in
                if b != nil {
                    print(b)
                    self.barcodes.append(a)
                }
            }).perform()
        }
    }
    

    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .cyan
        view.setTitle("랜덤사진", for: .normal)
        return view
    }()
    
    let button1: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.setTitle("바코드검색", for: .normal)
        return view
    }()
    
    let button2: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.setTitle("바코드사진", for: .normal)
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .systemGray
        return view
    }()

}

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
