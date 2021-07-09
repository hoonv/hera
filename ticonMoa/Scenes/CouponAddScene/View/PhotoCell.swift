//
//  PhotoCell.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/08.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 10
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setSelectedCell() {
        imageView.snp.remakeConstraints { make in
            make.top.leading.equalToSuperview().offset(4)
            make.bottom.trailing.equalToSuperview().offset(-4)
        }
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "appColor")?.cgColor
    }
    
    override func prepareForReuse() {
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
        imageView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
