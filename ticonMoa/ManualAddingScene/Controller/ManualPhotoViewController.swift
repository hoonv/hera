//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import TesseractOCR
import RxSwift

class ManualPhotoViewController: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    var selectedImage: UIImage?
    let tesseract = G8Tesseract(language: "eng+kor")
    var viewModel = ManualViewModel(ocr: nil)
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tesseract?.delegate = self
        viewModel = ManualViewModel(ocr: tesseract)
    
        imageView.image = selectedImage
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        
        guard let image = selectedImage else { return }
        viewModel.input.requestTextRecognition(image: image, layer: imageView.layer)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bag = DisposeBag()
        super.viewDidDisappear(animated)
    }

    @IBAction func DoneTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
