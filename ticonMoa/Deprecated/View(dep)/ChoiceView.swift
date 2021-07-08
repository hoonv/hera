//
//  ChoiceView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/06.
//

import UIKit

class ChoiceView: UIView {

    private let nibName = "ChoiceView"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var contentView: UIView?
    
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
        view.layer.cornerRadius = self.frame.width / 4
        contentView = view
        view.isUserInteractionEnabled = true

        self.addSubview(view)
    }
    
    func toggle(isSelected: Bool) {
        if isSelected {
            contentView?.backgroundColor = UIColor(named: "secondOpacity")
            contentView?.layer.borderWidth = 0.8
            contentView?.layer.borderColor = UIColor(named: "secondColor")?.cgColor
        } else {
            contentView?.backgroundColor = .clear
            contentView?.layer.borderWidth = 0
        }
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
