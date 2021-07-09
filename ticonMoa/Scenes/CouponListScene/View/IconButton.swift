//
//  IconButton.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit
import SnapKit

class IconButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? .lightGray : .label
        }
    }
    private var iconName: String = ""
    
    var size: CGFloat = 0
    convenience init(systemName: String, size: CGFloat = 20) {
        self.init(frame: .zero)
        iconName = systemName
        self.size = size
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        setImage(UIImage.init(systemName: iconName), for: .normal)
        setPreferredSymbolConfiguration(.init(pointSize: size, weight: .semibold), forImageIn: .normal)
        tintColor = .label
    }
}
