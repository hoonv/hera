//
//  CategoryCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/31.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        containerView.backgroundColor = .black
//        titleLabel.textColor = .white
    }

}
