//
//  PhotoCollectionViewCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/31.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
    }
}
