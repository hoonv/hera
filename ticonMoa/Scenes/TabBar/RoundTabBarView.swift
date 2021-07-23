//
//  FloatingTabView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/30.
//

import UIKit

protocol RoundTabBarViewDelegate: class {
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
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    func createButton(normalImage: UIImage, selectedImage: UIImage, index: Int) -> UIButton {
        let button = UIButton()
        button.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
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
            button.tintColor = index == 0 ? UIColor(named: "appColor") : .black
        }
    }
}
