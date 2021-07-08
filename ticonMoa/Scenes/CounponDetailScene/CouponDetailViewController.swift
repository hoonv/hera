//
//  CouponDetailViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/03.
//

import UIKit

class CouponDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var gifticon: Coupon?
    
    @IBOutlet weak var deleteButton: UIButton!
    override func viewDidLoad() {
        imageView.image = gifticon?.image
        deleteButton.layer.cornerRadius = 15
        super.viewDidLoad()
    }
    @IBAction func deleteButtonTouched(_ sender: Any) {
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "삭제버튼을 누르면 쿠폰이 삭제됩니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        let ok = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            CoreDataManager.shared.delete(gifticon: self.gifticon)
            NotificationCenter.default.post(name: .newCouponRegistered, object: nil)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
