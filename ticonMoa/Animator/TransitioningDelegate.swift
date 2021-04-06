//
//  TransitioningDelegate.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/04/06.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    /// Interaction controller
    ///
    /// If gesture triggers transition, it will set will manage its own
    /// `UIPercentDrivenInteractiveTransition`, but it must set this
    /// reference to that interaction controller here, so that this
    /// knows whether it's interactive or not.

    weak var interactionController: UIPercentDrivenInteractiveTransition?

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInAnimator(transitionType: .presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInAnimator(transitionType: .dismissing)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

}

class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}
