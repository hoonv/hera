//
//  InputWithLabel.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/20.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class InputWithLabel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    convenience init(label: String, placeHolder: String) {
        self.init()
        self.label.text = label
        self.input.placeholder = placeHolder
    }
    
    func setupUI() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(input)
        
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        input.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let input: InputFieldView = {
        let input = InputFieldView(placeHolder: "이름을 입력하세요")
        return input
    }()
}

class DateWithLabel: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "유효기간"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
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
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(datePicker)
        
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
}
