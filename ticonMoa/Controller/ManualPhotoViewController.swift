//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import TesseractOCR


class ManualPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage?
    let tesseract = G8Tesseract(language:"eng+kor")

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        
        tesseract?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let brw = BarcodeRequestWrapper(image: selectedImage!, completion: { _ in })
        brw.requestDetection()
        
        let trw = TextRecognitionWrapper(image: selectedImage!, layer: imageView.layer, completion: { image in
            self.recognizeWithTesseract(image: image)
        })
        trw.perform()
        
        super.viewDidAppear(animated)
    }
        
    func recognizeWithTesseract(image: UIImage) {
        tesseract?.image = image
        tesseract?.recognize()
        print(tesseract?.recognizedText)
    }

    @IBAction func DoneTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ManualPhotoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            newImage = possibleImage
        }
        
        imageView.image = newImage
        
        picker.dismiss(animated: true)
    }
}


extension ManualPhotoViewController: G8TesseractDelegate {
}
