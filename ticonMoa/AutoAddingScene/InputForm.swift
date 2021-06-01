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
    func inputForm(_ inputForm: InputForm, nameDidChange: String)
    func inputForm(_ inputForm: InputForm, dateDidChange: String)
    func inputForm(_ inputForm: InputForm, brandDidChange: String)
    func inputForm(_ inputForm: InputForm, barcodeDidChange: String)

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
        nameTextField.text = gifticon.name
        brandTextField.text = gifticon.brand
        let date = gifticon.expiredDate.toString(dateFormat: "yyyy.MM.dd")
        let dateText =  date == "1970.01.01" ? "" : date
        dateTextField.text = dateText
        barcodeTextField.text = gifticon.barcode
    }
    
    func conform() {
        dateTextField.isEnabled = false
        nameTextField.isEnabled = false
        brandTextField.isEnabled = false
        barcodeTextField.isEnabled = false
        barcodeTextField.textColor = .systemGray3
        dateTextField.textColor = .systemGray3
        nameTextField.textColor = .systemGray3
        brandTextField.textColor = .systemGray3
    }
    
    func unlock() {
        dateTextField.isEnabled = true
        nameTextField.isEnabled = true
        brandTextField.isEnabled = true
        barcodeTextField.isEnabled = true
        barcodeTextField.textColor = .black
        dateTextField.textColor = .black
        nameTextField.textColor = .black
        brandTextField.textColor = .black
    }
    func isValid() -> Bool {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        if nameTextField.text != ""
            && brandTextField.text != ""
            && barcodeTextField.text != ""
            && df.date(from: dateTextField.text ?? "") != nil {
            return true
        }
        return false
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
        let text = textField.text ?? ""
        if textField == nameTextField {
            delegate?.inputForm(self, nameDidChange: text)
        }
        
        if textField == dateTextField {
            delegate?.inputForm(self, dateDidChange: text)
        }
        
        if textField == brandTextField {
            delegate?.inputForm(self, brandDidChange: text)
        }
        
        if textField == barcodeTextField {
            delegate?.inputForm(self, barcodeDidChange: text)
        }
        keyboardWillHide()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardWillShow()
    }
}
