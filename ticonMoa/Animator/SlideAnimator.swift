//
//  SlideAnimator.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/02.
//

import UIKit

final class SlideInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case presenting
        case dismissing
    }

    let transitionType: TransitionType

    init(transitionType: TransitionType) {
        self.transitionType = transitionType

        super.init()
    }
    
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        print("animateTransition start")
        
        guard let fromVC = ctx.viewController(forKey: .from),
            let toVC = ctx.viewController(forKey: .to),
            let snapshot = ctx.view(forKey: .from)?.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
    
        let containerView = ctx.containerView
        let initialFrame = ctx.initialFrame(for: fromVC)
        let finalFrame = ctx.finalFrame(for: toVC)
        
        snapshot.frame = initialFrame
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.frame = finalFrame

        if transitionType == .presenting {
//            toVC.view.frame.origin.x = -finalFrame.width

        } else {
//            toVC.view.frame.origin.x = finalFrame.width
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                       if self.transitionType == .presenting {
                           snapshot.frame.origin.x = finalFrame.width
                       } else {
                           snapshot.frame.origin.x = -finalFrame.width
                       }
                       toVC.view.frame = finalFrame
               })  { _ in
            snapshot.removeFromSuperview()
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("ended")
    }
    
}

