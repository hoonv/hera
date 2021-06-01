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
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var grayView: UIView!
    let photoManager = PhotoManager()
    let bag = DisposeBag()
    var imageBarcode = PublishSubject<(UIImage,String)>()
    var gificons: [Gifticon] = []
    
    private var selectedIndex = IndexPath(row: 0, section: 0) {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        setupUI()
        binding()
        horizontalScrollView.delegate = self
        super.viewDidLoad()
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    private func validGificons() -> Bool {
        let filtered = gificons.filter {
            $0.expiredDate == Date(timeIntervalSince1970: 0)
                || $0.name == ""
                || $0.barcode == ""
                || $0.brand == ""
        }
        if filtered.count > 0 { return false }
        return true
    }
    
    private func updateUI() {
        let c = gificons[selectedIndex.row]
        self.inputForm.configure(c)
        self.imageView.image = c.image
        horizontalScrollView.selectCell(category: c.category)
        self.collectionView.reloadData()
    }
    
    @IBAction func checkButtonTouched(_ sender: Any) {

    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        if !validGificons() {
            alert(message: "값을 입력하거나 올바른 값을 입력해주세요", title: "쿠폰을 등록할 수 없습니다.")
            return
        }
        
        for data in gificons {
            let isSuccess = CoreDataManager.shared.insert(gifticon: data)
            if isSuccess {
                guard let image = data.image else {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                let im = ImageManager()
                im.saveImage(imageName: data.imageName, image: image)
            }
        }
        NotificationCenter.default.post(name: .newCouponRegistered, object: nil)
        self.dismiss(animated: true, completion: nil)
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
        updateUI()
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

extension AutoPhotoViewController: HorizontalScrollViewDelegate {
    func horizontalScrollView(_ horizontal: HorizontalScrollView, didSelected category: String) {
        gificons[selectedIndex.row].category = category
    }

}
