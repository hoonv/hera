//
//  BottomButtonSet.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/23.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class BottomButtonSet: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        [trashButton, useItButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        trashButton.snp.makeConstraints { make in
            make.width.equalTo(trashButton.snp.height)
        }
        
        useItButton.snp.makeConstraints { make in
            make.width.equalTo(trashButton.snp.width).multipliedBy(4)
        }
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let trashButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .medium)
        button.setImage(UIImage(systemName: "trash", withConfiguration: symbolConfig), for: .normal)
        button.tintColor = .red
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
        return button
    }()
    
    let useItButton: UIButton = {
        let button = UIButton()
        button.setTitle("사용완료", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = UIColor(named: "appColor")
        button.layer.cornerRadius = 5
        return button
    }()
}
