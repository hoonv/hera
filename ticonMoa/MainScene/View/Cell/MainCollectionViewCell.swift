//
//  HomeCollectionViewCell2.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var moveButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 12
        bottomView.layer.cornerRadius = 12
        moveButton.layer.cornerRadius = 8
    }

}
