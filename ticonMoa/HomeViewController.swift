//
//  ViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//

import UIKit
import Photos
import Vision

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let startTime = Date()
    private var images: [UIImage] = [] {
        didSet {
            print(Date().timeIntervalSince1970 - self.startTime.timeIntervalSince1970)
            collectionView.reloadData()
//            collectionView.reloadItems(at: [IndexPath(row: images.count, section: 0)])
        }
    }
    private let photoManager = PhotoManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        photoManager.requestAuthAndGetAllPhotos { image in
            guard let image = image else { return }
            let bw = BarcodeRequestWrapper(image: image) {
                self.images.append($0)
            }
            bw.requestDetect()
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = images[indexPath.row]
        
//        cell.backgroundColor = .red
        return cell
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (self.view.frame.width - 20) / 3
        return CGSize(width: w, height: w)
    }
    
}
