//
//  CouponDetailViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/03.
//

import UIKit

class CouponDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var gifticon: Gifticon?
    
    override func viewDidLoad() {
        imageView.image = gifticon?.image
        super.viewDidLoad()
    }
}
