//
//  SearchCategoryCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/26.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class SearchCategoryCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        [imageView, opacityView, title].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        opacityView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(imageView)
        }
        
        title.snp.makeConstraints { make in
            make.center.equalTo(opacityView)
        }
    }
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "starbucks")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let opacityView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    let title: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.text = "title"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()
}
