//
//  PhotoCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 10
        whiteBorder.isHidden = true

        [imageView, whiteBorder].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        whiteBorder.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.trailing.equalToSuperview()
        }
    }
    
    func setSelectedCell() {
        self.layer.borderWidth = 2
        whiteBorder.isHidden = false
        self.layer.borderColor = UIColor(named: "appColor")?.cgColor
    }
    
    override func prepareForReuse() {
        self.layer.borderWidth = 0
        whiteBorder.isHidden = true
        self.layer.borderColor = nil
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let whiteBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
}
