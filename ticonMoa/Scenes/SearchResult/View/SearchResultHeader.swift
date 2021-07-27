//
//  SearchResultHeader.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/07/27.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class SearchResultHeader: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        
    }
    
    func setupUI() {
        self.backgroundColor = .systemBackground
        [searchBar, backButton].forEach {
            addSubview($0)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.leading.equalToSuperview().offset(12)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.searchBarStyle = .minimal
        view.setValue("취소 ", forKey: "cancelButtonText")
        view.showsCancelButton = false
        return view
    }()
    
    let backButton: UIButton = {
        let view = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)
        view.setImage(image, for: .normal)
        view.tintColor = .label
        return view
    }()
}
