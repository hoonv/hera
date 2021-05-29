//
//  ManualPhotoViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/12.
//

import UIKit
import RxSwift
import SwiftyTesseract
import FirebaseDatabase
import Firebase

class ManualPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var grayOpacityView: UIView!
    
    var selectedImage: UIImage?
    //db
    var ref = Database.database().reference()
    let currentuser = Auth.auth().currentUser?.email?.components(separatedBy: "@")[0]
    var text : [String] = []
    var coupon_num: Int = 0
    
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
        
        self.ref.child("User/\(self.currentuser!)/Coupon/").observe(.value, with: { (snapshot: DataSnapshot!) in
                    self.coupon_num = Int(snapshot.childrenCount)
                })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let data = Gifticon(name: name, barcode: barcode, brand: brand, date: Date())
        if CoreDataManager.shared.insert(gifticon: data) {
            guard let image = imageView.image else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            let im = ImageManager()
            im.saveImage(imageName: data.imageName, image: image)
            print("save Image")
        }
        
        print(data)
        
        //쿠폰 db 입력
        
        coupon_num += 1
        self.ref.child("User/\(self.currentuser!)/Coupon/").updateChildValues([String(coupon_num):""])
        
        let datefomatter = DateFormatter()
        datefomatter.dateFormat = "YYYY.MM.dd"
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Item":name])
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Brand":brand])
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Barcode":barcode])
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Expire date":datefomatter.string(from:data.expiredDate)])
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
