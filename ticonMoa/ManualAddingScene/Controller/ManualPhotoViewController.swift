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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func DoneTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
