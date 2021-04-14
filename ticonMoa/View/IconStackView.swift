//
//  IconStackView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/31.
//

import UIKit

protocol IconStackViewDelegate: AnyObject {
    func iconStackView(_ iconStackView: IconStackView, didSelected index : Int)
}

class IconStackView: UIView {

    var contentView: UIView?
    
    weak var delegate: IconStackViewDelegate?
    private let nibName = "IconStackView"
    private let buttonNames = ["plus.app", "ticket"]
    private let symbolConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
    
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
        contentView = view
        
        setupStackView()
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: setupButtons())
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 44 * buttonNames.count + 15 * (buttonNames.count - 1), height: 0))
    }
    
    private func setupButtons() -> [UIButton] {
        var buttons: [UIButton] = []
        for (index, item) in buttonNames.enumerated() {
            guard let normalImage = UIImage(systemName: item, withConfiguration: symbolConfig)?.withRenderingMode(.alwaysTemplate) else { continue }
            let button = createButton(normalImage: normalImage, index: index)
            buttons.append(button)
        }
        return buttons
    }
    
    func createButton(normalImage: UIImage, index: Int) -> UIButton {
        let button = IconButton()
        button.constrainWidth(constant: 44)
        button.constrainHeight(constant: 44)
        button.tintColor = .black
        button.setImage(normalImage, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(test), for: .touchDown)
        return button
    }
    
    @objc func test(_ sender: UIButton) {
        delegate?.iconStackView(self, didSelected: sender.tag)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
