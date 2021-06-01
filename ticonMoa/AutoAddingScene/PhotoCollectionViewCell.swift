//
//  PhotoCollectionViewCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/31.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    let opacityView = UIView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        opacityView.backgroundColor = UIColor(named: "checkOpacity")
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let check = UIImageView(image: UIImage(systemName: "checkmark", withConfiguration: configuration))
        check.tintColor = UIColor(named: "checkColor")
        opacityView.addSubview(check)
        check.centerInSuperview()
        check.constrainWidth(constant: 20)
        check.constrainHeight(constant: 20)
    }

    override func prepareForReuse() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        opacityView.removeFromSuperview()
    }
    
    func setCheckmark() {
        self.addSubview(opacityView)
        opacityView.fillSuperview()
    }
}
