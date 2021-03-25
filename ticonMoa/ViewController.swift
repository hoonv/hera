//
//  ViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//

import UIKit
import Photos
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let startTime = Date()
    private var images: [UIImage] = [] {
        didSet {
            print(Date().timeIntervalSince1970 - self.startTime.timeIntervalSince1970)
            collectionView.reloadData()
        }
    }
    private let photoManager = PhotoManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        photoManager.requestAuthAndGetAllPhotos { image in
            guard let image = image else { return }
            let bw = BarcodeWrapper(image: image) {
                self.images.append($0)
            }
            bw.requestBarcode()
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.image.image = images[indexPath.row]
        return cell
        
    }
}
