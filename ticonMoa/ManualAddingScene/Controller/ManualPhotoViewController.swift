//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyTesseract

class ManualPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var grayOpacityView: UIView!
    
    @IBOutlet weak var horizontalScrollView: HorizontalScrollView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    var selectedImage: Observable<UIImage>?
    
    var viewModel = ManualViewModel()
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedImage?
            .subscribe(onNext: { image in
                self.imageView.image = image
                self.viewModel.input.executeOCR(image: image)
            })
            .disposed(by: bag)
    }
    
    private func setupUI() {
        nameTextField.delegate = self
        nameTextField.returnKeyType = .next
        brandTextField.delegate = self
        brandTextField.returnKeyType = .next
        dateTextField.delegate = self
        dateTextField.returnKeyType = .next
        barcodeTextField.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        grayOpacityView.layer.cornerRadius = 20
    }
    
    private func binding() {
        cancelButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        viewModel.output.isProccessing
            .observeOn(MainScheduler.instance)
            .filter { $0 == false }
            .subscribe(onNext: { _ in
                self.grayOpacityView.isHidden = true
                self.indicator.stopAnimating()
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
//            .map { $0.toString(dateFormat: "yyyy.MM.dd") }
            .subscribe(onNext: { str in
                self.dateTextField.text = str
            })
            .disposed(by: bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    func keyboardWillShow() {
        if topConstraint.constant != -260 {
            topConstraint.constant = -260
            UIView.animate(withDuration: 0.20, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    func keyboardWillHide() {
        if topConstraint.constant != 20 {
            topConstraint.constant = 20
        }
    }
    

    @IBAction func DoneTouched(_ sender: Any) {
        guard let name = nameTextField.text,
        let brand = brandTextField.text,
        let barcode = barcodeTextField.text,
        let textDate = dateTextField.text,
        name != "", brand != "", barcode != "", textDate != "" else {
            alert(message: "fill empty text")
            return
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        guard let date = df.date(from: textDate) else { return }
        let data = Gifticon(name: name, barcode: barcode, brand: brand, date: date, category: horizontalScrollView.selectedCategory)
        if CoreDataManager.shared.isExist(gifticon: data) {
            alert(message: "duplicated coupon")
            return
        }
        let isSuccess = CoreDataManager.shared.insert(gifticon: data)
        if isSuccess {
            guard let image = imageView.image else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            let im = ImageManager()
            im.saveImage(imageName: data.imageName, image: image)
            NotificationCenter.default.post(name: .newCouponRegistered, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        alert(message: "fail saving coupon")
    }
}

extension ManualPhotoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(nameTextField) {
            dateTextField.becomeFirstResponder()
        }
        if textField.isEqual(dateTextField) {
            brandTextField.becomeFirstResponder()
        }
        if textField.isEqual(brandTextField) {
            barcodeTextField.becomeFirstResponder()
        }
        if textField.isEqual(barcodeTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardWillHide()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardWillShow()
    }
}

extension UIViewController {
  func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

extension Notification.Name {
    static let newCouponRegistered = Notification.Name(rawValue: "newCouponRegistered")
}
