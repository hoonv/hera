//
//  PhotoScanInputForm.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/19.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class PhotoScanInputForm: UIView {
    
    var keyboardWillShow: (()-> Void)?
    var keyboardWillHide: (()-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        [nameInput, brandInput, expiredInput, barcodeInput].forEach {
            if $0 == barcodeInput {
                $0.delegate = self
                return
            }
            $0.delegate = self
            $0.returnKeyType = .next
        }

        [nameLabel, nameInput, brandLabel, brandInput,
         expiredLabel, expiredInput, barcodeLabel, barcodeInput].forEach {
            self.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }

        nameInput.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(nameInput.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
        }

        brandInput.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        expiredLabel.snp.makeConstraints { make in
            make.top.equalTo(brandInput.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
        }

        expiredInput.snp.makeConstraints { make in
            make.top.equalTo(expiredLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        barcodeLabel.snp.makeConstraints { make in
            make.top.equalTo(expiredInput.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
        }

        barcodeInput.snp.makeConstraints { make in
            make.top.equalTo(barcodeLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func configureTextFeild(viewModel: CouponScan.ScanPhoto.ViewModel) {
        self.nameInput.text = viewModel.name
        self.brandInput.text = viewModel.brand
        self.expiredInput.text = viewModel.expiredDate
        self.barcodeInput.text = viewModel.barcode
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let nameInput: InputFieldView = {
        let input = InputFieldView(placeHolder: "이름 입력하세요")
        return input
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.text = "브랜드"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let brandInput: InputFieldView = {
        let input = InputFieldView(placeHolder: "브랜드를 입력하세요")
        return input
    }()
    
    let expiredLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "유효기간"
        return label
    }()
    
    let expiredInput: InputFieldView = {
        let input = InputFieldView(placeHolder: "유효기간을 입력하세요")
        return input
    }()
    
    let barcodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "바코드"
        return label
    }()
    
    let barcodeInput: InputFieldView = {
        let input = InputFieldView(placeHolder: "바코드를 입력하세요")
        return input
    }()
}

extension PhotoScanInputForm: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardWillShow?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        keyboardWillHide?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(nameInput) {
            brandInput.becomeFirstResponder()
        }
        if textField.isEqual(brandInput) {
            expiredInput.becomeFirstResponder()
        }
        if textField.isEqual(expiredInput) {
            barcodeInput.becomeFirstResponder()
        }
        if textField.isEqual(barcodeInput) {
            textField.resignFirstResponder()
        }
        return true
    }
}
