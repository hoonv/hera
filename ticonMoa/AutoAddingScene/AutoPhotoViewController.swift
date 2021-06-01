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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    let photoManager = PhotoManager()
    let bag = DisposeBag()
    var imageBarcode = PublishSubject<(UIImage,String)>()
    var gificons: [Gifticon] = []
    
    private var selectedIndex = IndexPath(row: 0, section: 0) {
        didSet {
            let c = gificons[selectedIndex.row]
            self.inputForm.configure(c)
            self.imageView.image = c.image
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        setupUI()
        binding()
        super.viewDidLoad()
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }


    @IBAction func checkButtonTouched(_ sender: Any) {
        
    }
    
    @IBAction func trashButtonTouched(_ sender: Any) {
        if gificons.count == 1 {
            alert(message: "최소한 하나의 쿠폰은 필요합니다.", title: "쿠폰을 지울 수 없습니다.")
            return
        }
        gificons.remove(at: selectedIndex.row)
        if selectedIndex.row == gificons.count {
            selectedIndex = IndexPath(row: gificons.count - 1, section: 0)
        }
        collectionView.reloadData()
    }
}

extension AutoPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gificons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        cell.imageView.image = gificons[indexPath.row].image
        cell.layer.cornerRadius = 10
        if selectedIndex == indexPath {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor(named: "checkColor")?.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
    }
}
extension AutoPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

extension AutoPhotoViewController: InputFormDelegate {
    func inputForm(_ inputForm: InputForm, nameDidChange: String) {
        let row = selectedIndex.row
        gificons[row].name = nameDidChange
    }
    
    func inputForm(_ inputForm: InputForm, dateDidChange: String) {
        let row = selectedIndex.row
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        let date = df.date(from: dateDidChange) ?? Date(timeIntervalSince1970: 0)
        gificons[row].expiredDate = date
    }
    
    func inputForm(_ inputForm: InputForm, brandDidChange: String) {
        let row = selectedIndex.row
        gificons[row].brand = brandDidChange
    }
    
    func inputForm(_ inputForm: InputForm, barcodeDidChange: String) {
        let row = selectedIndex.row
        gificons[row].barcode = barcodeDidChange
    }
    
    func inputForm(_ inputForm: InputForm, keyboardWillShow: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
    }
    
    func inputForm(_ inputForm: InputForm, keyboardWillHide: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
