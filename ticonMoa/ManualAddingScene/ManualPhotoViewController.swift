//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import TesseractOCR
import FirebaseDatabase
import Firebase
class ManualPhotoViewController: UIViewController {
    
    var ref = Database.database().reference()
    
    let currentuser = Auth.auth().currentUser?.email?.components(separatedBy: "@")[0]
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: UIImage?
    let tesseract = G8Tesseract(language:"eng+kor")
    
    
    var text : [String] = []
    var coupon_num: Int = 0
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        
        self.ref.child("User/\(self.currentuser!)/Coupon/").observe(.value, with: { (snapshot: DataSnapshot!) in
            self.coupon_num = Int(snapshot.childrenCount)
        })
        tesseract?.delegate = self
        let brw = BarcodeRequestWrapper(image: selectedImage!, completion: { _ in })
        brw.requestDetection()

        let trw = TextRecognitionWrapper(image: selectedImage!, layer: imageView.layer, completion: { image in
            let ret = self.recognizeWithTesseract(image: image)
            
            
            DispatchQueue.main.async {
                self.textView.text = self.textView.text + ret
                self.text.append(ret)
                print("----------")
            }
        })
        DispatchQueue.global().async {
            trw.perform()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
    }
        
    func recognizeWithTesseract(image: UIImage) -> String {
        tesseract?.image = image
        tesseract?.recognize()
        return tesseract?.recognizedText ?? ""
    }

    @IBAction func DoneTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        coupon_num += 1
        self.ref.child("User/\(self.currentuser!)/Coupon/").updateChildValues([String(coupon_num):""])

        for (idx,value) in text.enumerated(){
            self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues([String(idx):value])
        }
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
