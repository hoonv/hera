//
//  newCouponListCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/09/14.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class NewCouponListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(viewModel: ViewModelCoupon) {
        brandLabel.text = viewModel.brand
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.dateString
        dateTag.setTitle(viewModel.remainDayString, for: .normal)
        dateTag.backgroundColor = viewModel.tagColor
        imageView.image = viewModel.image
    }
    
    private func setup() {
        [imageView, nameLabel, brandLabel, dateTag].forEach {
            contentView.addSubview($0)
        }

        imageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.equalTo(dateTag.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(20)
        }
        dateTag.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(20)
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
        name.numberOfLines = 1
        name.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return name
    }()
    
    let brandLabel: UILabel = {
        let brand = UILabel()
        brand.text = "스타벅스"
        brand.numberOfLines = 0
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
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        button.setTitle("D-20", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.tintColor = .white // this will be the textColor
        button.isUserInteractionEnabled = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 4
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    let separator: UIView = {
        let sep = UIView()
        sep.backgroundColor = .systemGray5
        return sep
    }()
}

