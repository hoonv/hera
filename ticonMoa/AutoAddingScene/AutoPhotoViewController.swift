//
//  AutoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/31.
//

import UIKit
import RxSwift

class AutoPhotoViewController: UIViewController {

    @IBOutlet weak var inputForm: InputForm!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalScrollView: HorizontalScrollView!

    private let photoManager = PhotoManager()
    private let bag = DisposeBag()
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        let categories = horizontalScrollView.names.dropFirst().map { String($0) }
        horizontalScrollView.setCategory(categories: categories)
        photoManager.requestAuthorization()
        photoManager.imageOutput
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                let barcodeDetector = BarcodeRequestWrapper(image: image) { [weak self] uiimage, payload  in
                    guard let self = self else { return }
                    self.images.append(image)
                    self.collectionView.reloadData()
                }
                barcodeDetector.perform()
            })
            .disposed(by: bag)
        inputForm.delegate = self
        super.viewDidLoad()
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        self.view.endEditing(true)
    }
}

extension AutoPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        cell.imageView.image = images[indexPath.row]
        cell.imageView.layer.cornerRadius = 15
        return cell
    }
}
extension AutoPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension AutoPhotoViewController: InputFormDelegate {
    func inputForm(_ inputForm: InputForm, keyboardWillShow: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    func inputForm(_ inputForm: InputForm, keyboardWillHide: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
}
