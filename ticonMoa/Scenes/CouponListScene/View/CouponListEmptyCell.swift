//
//  CouponListEmptyCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/09/14.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class CouponListEmptyCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plus")
        return view
    }()
    
    let descLabel: UILabel = {
        let view = UILabel()
        view.text = "쿠폰을 추가하세요!"
        view.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
        self.layer.cornerRadius = 30
        self.backgroundColor = .systemGray6
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
