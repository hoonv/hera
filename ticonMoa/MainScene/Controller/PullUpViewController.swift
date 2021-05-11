//
//  PullUpViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/06.
//

import UIKit

enum PullUpFinishState {
    case cancel
    case manaul
    case auto
}

class PullUpViewController: UIViewController {

    static let identifier: String = String(describing: PullUpViewController.self)
    
    @IBOutlet weak var autoView: ChoiceView!
    @IBOutlet weak var manualView: ChoiceView!
    
    @IBOutlet weak var pullUpView: UIView!
    
    @IBOutlet weak var goButton: ExpandButton!
    
    var isManaul = true
    var dismissClosure: ((PullUpFinishState) -> Void)?
    
    private var pullUpviewHeight: CGFloat {
        view.frame.height * 0.45
    }
    private var pullUpviewY: CGFloat {
        view.frame.height * 0.55
    }
    
    @IBAction func goButtonTouched(_ sender: Any) {
        let state: PullUpFinishState = isManaul ? .manaul : .auto
        movePullUpToHide(state: state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpShortLine()
        let autoWidth = (view.frame.width - 90) / 2
        
        manualView.frame = CGRect(x: 40, y: 30, width: autoWidth, height: autoWidth * 1.1)
        autoView.frame = CGRect(x: 50 + autoWidth, y: 30, width: autoWidth, height: autoWidth * 1.1)
        autoView.imageView.image = UIImage(named: "robot")
        manualView.imageView.image = UIImage(named: "technician")
        autoView.toggle(isSelected: false)
        manualView.toggle(isSelected: true)
        autoView.label.text = "auto"
        manualView.label.text = "manual"

        let manualTapGesture = UITapGestureRecognizer(target: self, action: #selector(manualTapped))
        let autoTapGesture = UITapGestureRecognizer(target: self, action: #selector(autoTapped))
        manualView.addGestureRecognizer(manualTapGesture)
        autoView.addGestureRecognizer(autoTapGesture)
        
        goButton.frame = CGRect(x: (view.frame.width - 182) / 2, y: autoWidth * 1.1 + 70, width: 182, height: 44)
        goButton.layer.cornerRadius = 20
        
        pullUpView.frame = CGRect(x: 0,
                                  y: view.frame.height - pullUpviewHeight / 2,
                                  width: view.frame.width,
                                  height: pullUpviewHeight)
        
        pullUpView.layer.cornerRadius = 30
        pullUpView.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        pullUpView.layer.shadowColor = UIColor.label.cgColor
        pullUpView.layer.shadowOpacity = 0.2
        pullUpView.layer.shadowOffset = CGSize(width: 0, height: -2)
        pullUpView.layer.shadowRadius = 30
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRe))
        pullUpView.addGestureRecognizer(panGesture)
        
    }
    
    @objc func manualTapped(_ sender: UITapGestureRecognizer) {
        toggle(flag: true)
    }
    
    @objc func autoTapped(_ sender: UITapGestureRecognizer) {
        toggle(flag: false)

    }
    
    private func toggle(flag: Bool) {
        isManaul = flag
        manualView.toggle(isSelected: isManaul)
        autoView.toggle(isSelected: !isManaul)
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
    
    func movePullUpToHide(state: PullUpFinishState = .cancel) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.pullUpView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { _ in
            self.dismissClosure?(state)
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
