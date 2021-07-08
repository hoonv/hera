//
//  CouponListCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021  . All rights reserved.
//

import UIKit
import SnapKit

class CouponListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        [imageView, separator, descStackView, dateStackView].forEach {
            contentView.addSubview($0)
        }

        [nameLabel, brandLabel, dateLabel].forEach {
            descStackView.addArrangedSubview($0)
        }
        
        [dateTag].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(20)
            make.bottom.equalTo(imageView.snp.bottom)
            make.leading.greaterThanOrEqualTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        descStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.bottom.lessThanOrEqualTo(dateStackView)
            make.leading.equalTo(imageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageView.snp.height)
            make.leading.equalToSuperview()
            make.top.equalTo(contentView).offset(12)
            make.bottom.equalTo(separator).offset(-12)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(0.8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(50)
        }
    }
    
    let dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    let descStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    let nameLabel: UILabel = {
        let name = UILabel()
        name.text = "촉촉한 카스테라와 함꼐하는 아메리카노 2잔"
        name.numberOfLines = 2
        name.lineBreakMode = .byCharWrapping
        name.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return name
    }()
    
    let brandLabel: UILabel = {
        let brand = UILabel()
        brand.text = "스타벅스"
        brand.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        brand.textColor = .systemGray
        return brand
    }()
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.text = "2021.07.21까지"
        date.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return date
    }()
    
    let dateTag: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        button.setTitle("D-20", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.tintColor = .white // this will be the textColor
        button.isUserInteractionEnabled = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 2
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sampleCoupon")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let separator: UIView = {
        let sep = UIView()
        sep.backgroundColor = .systemGray5
        return sep
    }()
}
