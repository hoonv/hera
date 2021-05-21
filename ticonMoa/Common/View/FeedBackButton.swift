//
//  FeedBackButton.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/12.
//

import UIKit

class FeedBackButton: ExpandButton {
    
    var feedbackGenerator: UISelectionFeedbackGenerator?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
      
    override func setup() {
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        self.rx.controlEvent(.touchUpInside)
            .bind { [weak self] in
                self?.feedbackGenerator?.selectionChanged()
            }.disposed(by: bag)
    }
}
