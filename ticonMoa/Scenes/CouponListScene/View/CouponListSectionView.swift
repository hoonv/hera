//
//  CouponListSectionView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/23.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class CouponListSectionView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(name)
        
        name.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    let name: UILabel = {
        let label = UILabel()
        label.text = "123123"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
}
