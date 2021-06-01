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
        
        generateNotification(notificationCenter: notificationCenter, item: data.name, expired_date_dateformat: data.expiredDate)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func generateNotification(notificationCenter : UNUserNotificationCenter ,item : String, expired_date_dateformat : Date){
        //현재 등록하려는 쿠폰과 유효기간이 같은 요청의 쿠폰 갯수를 불러온다.
        var removeIdentifiers = [String]()
        var expired_date_cnt : Int = 0
        let expired_date_str = self.convertDateFormatter(date: expired_date_dateformat)
        //쿠폰들 중 등록 쿠폰과의 유효기간이 같은것들 cnt(트리거에 쓰일예정)
        self.ref.child("User/\(self.currentuser!)/Coupon/").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let dataSnapshot = child as? DataSnapshot
                let item = dataSnapshot?.value as? NSDictionary
                if(item?["Expire date"] as! String == expired_date_str) {
                    print(item?["Brand"])
                    expired_date_cnt += 1
                }
            }
            
            //firebase에서 데이터를 반환하기 전에 실행되는 문제때문에 observe안에 넣어주었다.
            notificationCenter.getPendingNotificationRequests {
                (requests) in
                
                for request in requests {
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                       let nexttrigger = trigger.nextTriggerDate(){
                        //등록하는 쿠폰의 유효기간과 같은 trigger 제거하기 위해 배열에 넣어주기
                        //같은 날짜의 쿠폰이 한번 더 등록될때 전에 등록했던 트리거를 수정해주기 위함
                        if self.convertDateFormatter(date: nexttrigger) == self.convertDateFormatter(date: expired_date_dateformat) {
                            removeIdentifiers.append(request.identifier)
                        }
                    }
                }
                
                
                print("removeIdentifer")
                print(removeIdentifiers)
                //같은 날짜의 request들을 지워준다. -> 후에 현재 쿠폰을 더한 Notificaiton을 추가해줄 예정
                notificationCenter.removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
                
                
                print("expire_date_cnt.  " + String(expired_date_cnt))
                //for test(쿠폰 등록 후 2분 뒤에 알람)
                self.day137_request(day_idx: 0, notificationCenter: notificationCenter, item: item, expired_date_cnt: expired_date_cnt, expired_date_dateformat: expired_date_dateformat)
            }
            
            
            
            /*
             
            //D-1
            self.day137_request(day_idx: 1, notificationCenter: notificationCenter, item: item, expired_date_cnt: expired_date_cnt, expired_date_dateformat: expired_date_dateformat)
            //D-3
            self.day137_request(day_idx: 3, notificationCenter: notificationCenter, item: item, expired_date_cnt: expired_date_cnt, expired_date_dateformat: expired_date_dateformat)
            //D-7
            self.day137_request(day_idx: 7, notificationCenter: notificationCenter, item: item, expired_date_cnt: expired_date_cnt, expired_date_dateformat: expired_date_dateformat)
            */
        })
        
        
        
        
    }
    func convertDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"///this is what you want to convert format
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
     }
    func day137_request(day_idx : Int,notificationCenter : UNUserNotificationCenter,item : String, expired_date_cnt : Int,expired_date_dateformat : Date){
        
        
        
        //화면에 보여지는 빨간색
        //content.badge = 2
        if day_idx == 1{
            let content = UNMutableNotificationContent()
            
            content.title = "유효기간 알림"
            content.body = "유효기간이 1일 남은 쿠폰이 " + String(expired_date_cnt) + "개 입니다."
            content.sound = UNNotificationSound.default
            
            let trigger_date = Calendar.current.date(byAdding: .day, value: -1, to: expired_date_dateformat)!
            let datecomponents = Calendar.current.dateComponents([.year,.month,.day], from: trigger_date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
            //알림의 고유 이름
            let identifier = item
            //등록할 결과물
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            
            //UNUserNotificationCenter.current()에 등록
            notificationCenter.add(request) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        }
        else if day_idx == 3{
            let content = UNMutableNotificationContent()
            
            content.title = "유효기간 알림"
            content.body = "유효기간이 3일 남은 쿠폰이 " + String(expired_date_cnt) + "개 입니다."
            content.sound = UNNotificationSound.default
            
            let trigger_date = Calendar.current.date(byAdding: .day, value: -3, to: expired_date_dateformat)!
            let datecomponents = Calendar.current.dateComponents([.year,.month,.day], from: trigger_date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
            //알림의 고유 이름
            let identifier = item
            //등록할 결과물
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            
            //UNUserNotificationCenter.current()에 등록
            notificationCenter.add(request) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        }
        else if day_idx == 7{
            let content = UNMutableNotificationContent()
            
            content.title = "유효기간 알림"
            content.body = "유효기간이 7일 남은 쿠폰이 " + String(expired_date_cnt) + "개 입니다."
            content.sound = UNNotificationSound.default
            
            //유효기간에서 7일전 날짜 date형식 구하기
            let trigger_date = Calendar.current.date(byAdding: .day, value: -7, to: expired_date_dateformat)!
            //유효기간 7일전 날짜를 datecomponent형식으로 변환(ex.2021,06,01
            let datecomponents = Calendar.current.dateComponents([.year,.month,.day], from: trigger_date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
            //알림의 고유 이름
            let identifier = item
            //등록할 결과물
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            
            //UNUserNotificationCenter.current()에 등록
            notificationCenter.add(request) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        }
        else{//for test
            let content = UNMutableNotificationContent()
            
            content.title = "유효기간 알림"
            content.body = "유효기간이 7일 남은 쿠폰이 " + String(expired_date_cnt) + "개 있습니다.\n기한 안에 사용해주세요!"
            content.sound = UNNotificationSound.default
            
            let current_date = Date()
            let test_day = Calendar.current.component(.day, from: current_date)
            let test_hour = Calendar.current.component(.hour, from: current_date)
            let test_minute = Calendar.current.component(.minute, from: current_date)
            
            
            let dateComponents = DateComponents(year: 2021, month: 6, day: test_day,hour: test_hour,minute:test_minute + 2)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            //알림의 고유 이름
            let identifier = item
            //등록할 결과물
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            print(dateComponents)
            //UNUserNotificationCenter.current()에 등록
            notificationCenter.add(request) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        }
    }
}
