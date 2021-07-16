//
//  InputFieldView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/16.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit


class InputFieldView: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(placeHolder: String) {
        self.init(frame: .zero)
        self.placeholder = placeHolder
        self.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
}

