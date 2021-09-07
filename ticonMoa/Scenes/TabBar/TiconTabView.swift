//
//  TiconTabView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/09/02.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class TiconTabView: UIView {
    
    let sv = SketchedView()
    let stackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    init(_ icons: [String]) {
        super.init(frame: .zero)
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
        self.addSubview(sv)
        
        sv.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
}
