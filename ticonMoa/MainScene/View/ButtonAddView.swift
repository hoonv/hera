//
//  ButtonAddView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit

class ButtonAddView: UIView {

    private let nibName = "ButtonAddView"

    @IBOutlet weak var addButton: UIButton!
    
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
        addButton.layer.cornerRadius = 20
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowRadius = bounds.height / 5
    }
    
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
