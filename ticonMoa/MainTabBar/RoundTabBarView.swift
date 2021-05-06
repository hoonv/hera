//
//  FloatingTabView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/30.
//

import UIKit

protocol RoundTabBarViewDelegate: AnyObject {
    func roundTabBarView(_ roundTabBarView: RoundTabBarView, didSelected index : Int)
}

class RoundTabBarView: UIView {

    weak var delegate: RoundTabBarViewDelegate?

    var buttons: [UIButton] = []

    init(_ items: [String]) {
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupStackView(items)
        updateUI(selectedIndex: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        
        setupStackView([])
        updateUI(selectedIndex: 0)
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = bounds.height / 5
    }

    func setupStackView(_ items: [String]) {
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        
        for (index, item) in items.enumerated() {
            guard let normalImage = UIImage(systemName: item, withConfiguration: symbolConfig) else { continue }
            let selectedImage = UIImage(systemName: "\(item).fill", withConfiguration: symbolConfig)
            let button = createButton(normalImage: normalImage, selectedImage: selectedImage ?? normalImage, index: index)
            buttons.append(button)
        }

        let stackView = UIStackView(arrangedSubviews: buttons)

        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }

    func createButton(normalImage: UIImage, selectedImage: UIImage, index: Int) -> UIButton {
        let button = UIButton()
        button.constrainWidth(constant: 60)
        button.constrainHeight(constant: 60)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.setImage(selectedImage, for: [.highlighted , .selected])
        button.tag = index
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(changeTab(_:)), for: .touchUpInside)
        return button
    }

    @objc func changeTab(_ sender: UIButton) {
        sender.pulse()
        delegate?.roundTabBarView(self, didSelected: sender.tag)
        updateUI(selectedIndex: sender.tag)
    }

    func updateUI(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            if index != selectedIndex {
                button.isSelected = false
                button.tintColor = .gray
                continue
            }
            button.isSelected = true
            button.tintColor = index == 0 ? .red : .black
        }
    }
}

extension UIButton {

    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func shrink() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.fromValue = 1
        animation.toValue = 0.98
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "pulse")
    }
    
    func expand() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.fromValue = 1
        animation.toValue = 1.01
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "pulse")
    }
}
