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
    
    private var selectedIndex = IndexPath(row: 0, section: 0) {
        didSet {
            let c = gificons[selectedIndex.row]
            self.inputForm.configure(c)
            self.imageView.image = c.image
            self.collectionView.reloadData()
        }
    }
    private let photoManager = PhotoManager()
    private let bag = DisposeBag()
    private var imageBarcode = PublishSubject<(UIImage,String)>()
    var gificons: [Gifticon] = []
    
    override func viewDidLoad() {
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        let categories = horizontalScrollView.names.dropFirst().map { String($0) }
        horizontalScrollView.setCategory(categories: categories)
        photoManager.requestAuthorization()
        let barcodes: [String] = CoreDataManager.shared.fetchAll()
            .map { (c: Gifticon) -> String in
            c.barcode }
        photoManager.imageOutput
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { image in
                print(image)
                let barcodeDetector = BarcodeRequestWrapper(image: image) { [weak self] uiimage, payload  in
                    guard let self = self else { return }
                    if barcodes.contains(payload) {
                        return
                    }
                    self.imageBarcode.onNext((image, payload))
                }
                barcodeDetector.perform()
            })
            .disposed(by: bag)
        
        imageBarcode
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image, barcode in
                let ocr = OCRManager()
                let payloads: [[String]] = ocr.requestTextRecognition(image: image)

                let b = self.recognizeBrand(input: payloads) ?? ""
                let d = self.recognizeDate(input: payloads) ?? Date(timeIntervalSince1970: 0)
                let n = self.recognizeName(input: payloads) ?? ""
                var g = Gifticon(name: n,
                                 barcode: barcode,
                                 brand: b,
                                 date: d,
                                 category: self.horizontalScrollView.names[0])
                g.image = image
                if self.gificons.count == 0 {
                    self.inputForm.configure(g)
                    self.imageView.image = g.image
                }
                self.gificons.append(g)
                self.collectionView.reloadData()
            })
            .disposed(by: bag)
        inputForm.delegate = self
        trashButton.layer.cornerRadius = 10
        checkButton.layer.cornerRadius = 10
        super.viewDidLoad()
    }
    
    private func recognizeName(input: [[String]]) -> String? {
        let nameReg = NameRecognizer()
        for (idx, line) in input.enumerated() {
            let joined = line.joined()
            let n1 = input[safe: idx - 2]?.first
            let n2 = input[safe: idx - 1]?.first
            if let name = nameReg.match(input: joined, candidates: [n1,n2]) {
                return name
            }
        }
        return nil
    }
    
    private func recognizeDate(input: [[String]]) -> Date? {
        let dateReg = DateRecognizer()
        for line in input {
            for word in line {
                print(word)
                if let date = dateReg.match(input: word) {
                    return date
                }
            }
        }
        return nil
    }
    
    private func recognizeBrand(input: [[String]]) -> String? {
        let brandReg = BrandRecognizer()
        for line in input {
            for word in line {
                if let brand = brandReg.match(input: word) {
                    return brand
                }
            }
        }
        return nil
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
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
    func inputForm(_ inputForm: InputForm, keyboardWillShow: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
    }
    
    func inputForm(_ inputForm: InputForm, keyboardWillHide: Bool) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
