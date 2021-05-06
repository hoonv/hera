//
//  PullUpViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/06.
//

import UIKit

class PullUpViewController: UIViewController {

    static let identifier: String = String(describing: PullUpViewController.self)
    
    @IBOutlet weak var pullUpView: UIView!
    
    var dismissClosure: (() -> Void)?
    
    private var pullUpviewHeight: CGFloat {
        view.frame.height * 0.45
    }
    private var pullUpviewY: CGFloat {
        view.frame.height * 0.55
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpShortLine()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTappeded))
        pullUpView.frame = CGRect(x: 0,
                                  y: view.frame.height - pullUpviewHeight / 2,
                                  width: view.frame.width,
                                  height: pullUpviewHeight)
        pullUpView.addGestureRecognizer(tap)
        
        pullUpView.layer.cornerRadius = 30
        pullUpView.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        pullUpView.layer.shadowColor = UIColor.label.cgColor
        pullUpView.layer.shadowOpacity = 0.2
        pullUpView.layer.shadowOffset = CGSize(width: 0, height: -2)
        pullUpView.layer.shadowRadius = 30
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRe))
        pullUpView.addGestureRecognizer(panGesture)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: {
            self.pullUpView.frame = CGRect(x: 0,
                                      y: self.view.frame.height - self.pullUpviewHeight,
                                      width: self.view.frame.width,
                                      height: self.pullUpviewHeight)
        })
    }
    @objc func viewTappeded(_ sender: UIView) {
        print("x")
    }
    
    private func setUpShortLine() {
        let lineHeight: CGFloat = 5
        let lineView = UIView()
        lineView.layer.cornerRadius = lineHeight / 2
        lineView.backgroundColor = .systemGray4
        self.pullUpView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: self.pullUpView.topAnchor, constant: 6),
            lineView.centerXAnchor.constraint(equalTo: self.pullUpView.centerXAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 38),
            lineView.heightAnchor.constraint(equalToConstant: lineHeight)
        ])
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let transition = recognizer.translation(in: view)
        let positionY = pullUpView.frame.minY + transition.y
        
        if positionY < view.frame.height * 0.5 {
            return
        }
        
        pullUpView.frame = CGRect(x: 0, y: positionY, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: view)
    }
    
    
    func movePullUpToInitPosition() {
        UIView.animate(withDuration: 0.2) {
            self.pullUpView.frame = CGRect(x: 0, y: self.pullUpviewY, width: self.view.frame.width, height: self.pullUpviewHeight)
        }
    }
    
    func movePullUpToHide() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.pullUpView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { _ in
            self.dismissClosure?()
        })
    }
    @objc private func panGestureRe(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        guard recognizer.state == .ended && recognizer.location(in: view).y >= 0 else { return }
        
        let miny = pullUpView.frame.minY
        let velocity = recognizer.velocity(in: self.view).y
        
        if miny > view.frame.height * 0.8 || velocity > 300 {
            movePullUpToHide()
        } else {
            movePullUpToInitPosition()
            
        }
    }
    
}
