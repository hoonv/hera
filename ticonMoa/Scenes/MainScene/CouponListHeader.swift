//
//  CouponListHeader.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit
import SnapKit

class CouponListHeader: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        
        iconStackView.addArrangedSubview(searchIcon)
        iconStackView.addArrangedSubview(filterIcon)

        [separator, iconStackView].forEach {
            addSubview($0)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.width.equalTo(searchIcon.snp.height)
        }
        
        filterIcon.snp.makeConstraints { make in
            make.width.equalTo(filterIcon.snp.height)
        }

        iconStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(separator)
            make.top.equalToSuperview()
            make.width.greaterThanOrEqualTo(30)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
        
    }
    
    let iconStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let searchIcon: IconButton = {
        let button = IconButton(systemName: "magnifyingglass")
        return button
    }()
    
    let filterIcon: IconButton = {
        let button = IconButton(systemName: "slider.horizontal.3")
        return button
    }()

}
