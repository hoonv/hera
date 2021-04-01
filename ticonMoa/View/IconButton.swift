//
//  IconButton.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/01.
//

import UIKit

class IconButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? .lightGray : .black
        }
    }
    // 스토리보드에서 참고
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }

}
