//
//  SettingFormView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/22.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class SettingFormView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    convenience init(options: [String]) {
        self.init()
        self.options = options
        setupUI()
    }
    
    var options: [String] = []
    var optionView: [OptionView] = []
    func setupUI() {
        
        optionView = options.map { text -> OptionView in
            let view = OptionView()
            view.optionLabel.text = text
            return view
        }
        
        optionView.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionSelected))
            $0.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview($0)
        }
        
        [title, stackView].forEach {
            addSubview($0)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalTo(title.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc func optionSelected(_ gesture: UITapGestureRecognizer) {
        for i in 0..<optionView.count {
            if gesture.view == optionView[i] {
                optionView[i].isChecked = true
                continue
            }
            optionView[i].isChecked = false
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "사용완료쿠폰"
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    let option1: OptionView = {
        let option = OptionView()
        option.tag = 0
        option.optionLabel.text = "보이기"
        return option
    }()
    
    let option2: OptionView = {
        let option = OptionView()
        option.tag = 1
        option.optionLabel.text = "숨기기"
        return option
    }()
}
