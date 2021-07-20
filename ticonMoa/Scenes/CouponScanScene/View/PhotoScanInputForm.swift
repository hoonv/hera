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
        [nameInputLine, brandInputLine, dateInputLine, barcodeInputLine].forEach {
            if $0 == barcodeInputLine {
                $0.input.delegate = self
                return
            }
            $0.input.delegate = self
            $0.input.returnKeyType = .next
        }
        [nameInputLine, brandInputLine, dateInputLine, barcodeInputLine].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(snp.bottom)
        }
    }
    
    func configureTextFeild(viewModel: CouponScan.ScanPhoto.ViewModel) {
        self.nameInputLine.input.text = viewModel.name
        self.brandInputLine.input.text = viewModel.brand
        self.dateInputLine.input.text = viewModel.expiredDate
        self.barcodeInputLine.input.text = viewModel.barcode
    }
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 16
        return view
    }()
    
    let nameInputLine: InputWithLabel = {
        let view = InputWithLabel(label: "이름", placeHolder: "이름을 입력하세요")
        return view
    }()
    
    let barcodeInputLine: InputWithLabel = {
        let view = InputWithLabel(label: "바코드", placeHolder: "바코드를 입력하세요")
        return view
    }()
    
    let brandInputLine: InputWithLabel = {
        let view = InputWithLabel(label: "브랜드", placeHolder: "브랜드를 입력하세요")
        return view
    }()
    
    let dateInputLine: InputWithLabel = {
        let view = InputWithLabel(label: "유효기간", placeHolder: "유효기간을 입력하세요")
        return view
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
        if textField.isEqual(nameInputLine.input) {
            brandInputLine.becomeFirstResponder()
        }
        if textField.isEqual(brandInputLine.input) {
            dateInputLine.becomeFirstResponder()
        }
        if textField.isEqual(dateInputLine.input) {
            barcodeInputLine.becomeFirstResponder()
        }
        if textField.isEqual(barcodeInputLine.input) {
            textField.resignFirstResponder()
        }
        return true
    }
}
