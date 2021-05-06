//
//  HomeIconHeaderView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

class MainIconHeaderView: UIView {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    private let nibName = "MainIconHeaderView"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        searchButton.layer.cornerRadius = 12
        mapButton.layer.cornerRadius = 12
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
