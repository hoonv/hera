//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import RxSwift
import SwiftyTesseract

class ManualPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var grayOpacityView: UIView!
    
    var selectedImage: UIImage?
    
    var viewModel = ManualViewModel()
    var oneflag = false
    var isProccessing = false
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageView.image = selectedImage
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        grayOpacityView.layer.cornerRadius = 20
        binding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(CoreDataManager.shared.fetchAll().count)
        guard let image = selectedImage, oneflag == false else { return }
        viewModel.input.executeOCR(image: image)
        oneflag = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bag = DisposeBag()
        super.viewDidDisappear(animated)
    }
    
    func binding() {
        viewModel.output.isProccessing
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { flag in
                if !flag {
                    self.grayOpacityView.isHidden = true
                    self.indicator.stopAnimating()
                }
            })
            .disposed(by: bag)
        
        viewModel.output.name
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { payload in
                self.nameTextField.text = payload
            })
            .disposed(by: bag)
        
        viewModel.output.barcode
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { payload in
                self.barcodeTextField.text = payload
            })
            .disposed(by: bag)
        
        viewModel.output.brand
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { payload in
                self.brandTextField.text = payload
            })
            .disposed(by: bag)
        
        viewModel.output.expirationDate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { date in
                let dateString = date.toStringKST(dateFormat: "yyyy.MM.dd")
                self.dateTextField.text = dateString
            })
            .disposed(by: bag)
    }

    @IBAction func DoneTouched(_ sender: Any) {
        guard let name = nameTextField.text,
        let brand = brandTextField.text,
        let barcode = barcodeTextField.text else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let data = Gifticon(name: name, expiredDate: Date(), brand: brand, barcode: barcode, category: Category(name: "스타벅스", imageName: "dd"))
        CoreDataManager.shared.insert(gifticon: data)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
