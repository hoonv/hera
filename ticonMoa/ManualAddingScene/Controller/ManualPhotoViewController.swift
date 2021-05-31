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
    // for db
    var ref = Database.database().reference()
    let currentuser = Auth.auth().currentUser?.email?.components(separatedBy: "@")[0]
    var text : [String] = []
    var coupon_num: Int = 0
    // for notification
    let notificationCenter = UNUserNotificationCenter.current()

    
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
        
        
        //쿠폰 db 입력
        
        coupon_num += 1
        self.ref.child("User/\(self.currentuser!)/Coupon/").updateChildValues([String(coupon_num):""])
        
        let datefomatter = DateFormatter()
        datefomatter.dateFormat = "YYYY.MM.dd"
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Item":name])
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Brand":brand])
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Barcode":barcode])
        self.ref.child("User/\(self.currentuser!)/Coupon/\(String(coupon_num))/").updateChildValues(["Expire date":datefomatter.string(from:data.expiredDate)])
        
        //local notification
        //date 포맷 변경을 위해 string으로 유효기간을 넣어준다.
        // 쿠폰 등록을 누를때마다 알림을 업데이트해준다.
        generateNotification(item: data.name, expired_date_str: datefomatter.string(from : data.expiredDate))
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func generateNotification(item : String, expired_date_str : String){
        let notificationCenter = UNUserNotificationCenter.current()
        var expired_date_cnt : Int = 0
        //String to Date format

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let expired_date_dateformat = dateFormatter.date(from:expired_date_str)!
        print(expired_date_dateformat)
        //현재 등록하려는 쿠폰과 유효기간이 같은 요청의 쿠폰 갯수를 불러온다.
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            var removeIdentifiers = [String]()
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nexttrigger = trigger.nextTriggerDate(){
                    //요청중에 현재 쿠폰의 expired date와 같은 요청이 있다면 cnt해준다.
                    if nexttrigger == expired_date_dateformat{
                        removeIdentifiers.append(request.identifier)
                        expired_date_cnt += 1
                    }
                }
            }
            print("removeIdentifer")

            print(removeIdentifiers)
            //같은 날짜의 request들을 지워준다. -> 후에 현재 쿠폰을 더한Notificaiton을 추가해줄 예정
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = item
        content.body = "유효기간이 1일 남은 쿠폰이 " + String(expired_date_cnt) + "개 입니다."
        print("expired_date")
        print(expired_date_cnt)
        content.sound = UNNotificationSound.default
        //화면에 보여지는 빨간색
        content.badge = 2
        
        //언제 발생 시킬 것인지 알려준다.
        let trigger_date = Calendar.current.date(byAdding: .day, value: -1, to: expired_date_dateformat)!
        print("trigger_Date")
        print(trigger_date)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: trigger_date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //알림의 고유 이름
        let identifier = "Local Notification"
        //등록할 결과물
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        
        //UNUserNotificationCenter.current()에 등록
        notificationCenter.add(request) { (error) in
            if let err = error {
                print(err.localizedDescription)
            }
        }
        
    }
    
}
