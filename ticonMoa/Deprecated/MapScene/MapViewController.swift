//
//  PhotoAddViewController.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/02.
//

import UIKit

class MapViewController: UIViewController {

    let customTransitionDelegate = TransitioningDelegate()
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray
        transitioningDelegate = customTransitionDelegate
        let panUp = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(panUp)
        
        super.viewDidLoad()
    }


    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = -translate.x / gesture.view!.bounds.size.width

        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent * 0.8)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: gesture.view)
            if (percent > 0.5 && velocity.x == 0) || velocity.x < -100 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}
