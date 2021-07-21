//
//  CouponScanHeader.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/16.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit


class CouponScanHeader: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .systemBackground
        
        [backIcon].forEach {
            leftIconStackView.addArrangedSubview($0)
        }
        [completeIcon].forEach {
            iconStackView.addArrangedSubview($0)
        }
        
        [separator, leftIconStackView, iconStackView].forEach {
            addSubview($0)
        }
        
        iconStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(separator)
            make.top.equalToSuperview()
            make.width.greaterThanOrEqualTo(60)
        }
        
        leftIconStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalTo(separator)
            make.top.equalToSuperview()
            make.width.greaterThanOrEqualTo(60)
        }
    
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
    }
    
    let iconStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let leftIconStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let backIcon: IconButton = {
        let button = IconButton(systemName: "chevron.backward")
        return button
    }()
    
    let completeIcon: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
}
