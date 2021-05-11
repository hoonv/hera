//
//  ExpandButton.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/11.
//

import UIKit
import RxSwift
import RxCocoa

class ExpandButton: UIButton {
    
    var bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    func setup() {
        self.rx.controlEvent(.touchDown)
            .bind { [weak self] in
                self?.shrink()
            }.disposed(by: bag)
        self.rx.controlEvent(.touchUpInside)
            .bind { [weak self] in
                self?.expand()
            }.disposed(by: bag)
    }
}

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
