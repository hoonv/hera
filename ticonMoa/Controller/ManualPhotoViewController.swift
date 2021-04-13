//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit

class ManualPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let brw = BarcodeRequestWrapper(image: selectedImage!, completion: { _ in })
        brw.requestDetection()
        
        let trw = TextRecognitionWrapper(image: selectedImage!, layer: imageView.layer, completion: { image in
            print(image)
        })
        trw.perform()
        
        super.viewDidAppear(animated)
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

