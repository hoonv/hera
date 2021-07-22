//
//  OptionView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/22.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class OptionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        
        stackView.addArrangedSubview(optionLabel)
        stackView.addArrangedSubview(checkView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        checkView.snp.makeConstraints { make in
            make.width.equalTo(optionLabel.snp.width).multipliedBy(0.25)
        }
    }
    
    var isChecked = false {
        didSet {
            if isChecked {
                showCheckMark()
            } else {
                hideCheckMark()
            }
        }
    }
    
    func showCheckMark() {
        checkView.image = image
    }
    
    func hideCheckMark() {
        checkView.image = nil
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.text = "보이기"
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        return label
    }()
    
    let checkView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    var image: UIImage? {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        return UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
    }
}
