//
//  SketchedView.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/09/01.
//  Copyright © 2021 hoon. All rights reserved.
//

import UIKit

class SketchedView: UIView {
    
    private var flag = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = min(self.frame.width, self.frame.height) / 5
    }
    
    override func draw(_ rect: CGRect) {
        if flag {
            return
        }
        let r = layer.cornerRadius
        let w: CGFloat = rect.maxX * 0.95
        let xdiff: CGFloat = rect.maxX * 0.05 / 2
        let ydiff: CGFloat = 5
        
  
        let center1 = CGPoint(x: rect.minX + r + xdiff,
                              y: rect.maxY - r + ydiff)
        let center2 = CGPoint(x: rect.maxX - r - xdiff,
                              y: rect.maxY - r + ydiff)
        let midPoint = CGPoint(x: center2.x, y: center2.y + r)
        let aPath = UIBezierPath()
//        aPath.move(to: startPoint)
        aPath.addArc(withCenter: center1,
                     radius: r,
                     startAngle: (150 * .pi) / 180,
                     endAngle: (90 * .pi) / 180,
                     clockwise: false)
        
        aPath.addLine(to: midPoint)
        aPath.addArc(withCenter: center2,
                     radius: r,
                     startAngle: (90 * .pi) / 180,
                     endAngle: (30 * .pi) / 180,
                     clockwise: false)
        aPath.stroke()
        
        let shape = CAShapeLayer()
        shape.path = aPath.cgPath
        shape.backgroundColor = UIColor.clear.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        shape.lineWidth = 2
        self.layer.addSublayer(shape)
        flag = true
    }
    
}
