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
    }
    
    override func prepareForReuse() {
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }

}
