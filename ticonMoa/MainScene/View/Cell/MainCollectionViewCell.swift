//
//  HomeCollectionViewCell2.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        
        self.containerView.layer.cornerRadius = 30
        self.containerView.layer.masksToBounds = true

    }

}
