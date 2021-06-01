//
//  InputForm.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/06/01.
//

import UIKit

protocol InputFormDelegate: class {
    func inputForm(_ inputForm: InputForm, keyboardWillShow: Bool)
    func inputForm(_ inputForm: InputForm, keyboardWillHide: Bool)
}

class InputForm: UIView {

    private let nibName = "InputForm"
    var contentView: UIView?
    weak var delegate: InputFormDelegate?
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView = view
        view.isUserInteractionEnabled = true
        nameTextField.delegate = self
        nameTextField.returnKeyType = .next
        brandTextField.delegate = self
        brandTextField.returnKeyType = .next
        dateTextField.delegate = self
        dateTextField.returnKeyType = .next
        barcodeTextField.delegate = self
        self.addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        self.contentView?.endEditing(true)
    }
    
    func configure(_ gifticon: Gifticon) {
        print(gifticon)
        nameTextField.text = gifticon.name
        brandTextField.text = gifticon.brand
        let date = gifticon.expiredDate.toString(dateFormat: "yyyy.MM.dd")
        let dateText =  date == "1970.01.01" ? "" : date
        dateTextField.text = dateText
        barcodeTextField.text = gifticon.barcode

    }
    
    func keyboardWillShow() {
        delegate?.inputForm(self, keyboardWillShow: true)
    }
    
    func keyboardWillHide() {
        delegate?.inputForm(self, keyboardWillHide: true)
    }
}

extension InputForm: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(nameTextField) {
            dateTextField.becomeFirstResponder()
        }
        if textField.isEqual(dateTextField) {
            brandTextField.becomeFirstResponder()
        }
        if textField.isEqual(brandTextField) {
            barcodeTextField.becomeFirstResponder()
        }
        if textField.isEqual(barcodeTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardWillHide()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardWillShow()
    }
}
