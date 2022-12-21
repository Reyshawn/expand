//
//  ShrinkAnimator.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/9/27.
//

import UIKit

class ShrinkAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  static let duration: TimeInterval = 0.4
  var forDismissed: Bool = false
  
  let interactionController: ShrinkInteractionController?
  
  init(interactionController: ShrinkInteractionController) {
    self.interactionController = interactionController
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Self.duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // let fromView = presenting.view!
    let containerView = transitionContext.containerView
    let fromView = transitionContext.view(forKey: .from)!
    let toView = transitionContext.view(forKey: .to)!

    if forDismissed {
      UIView.animate(withDuration: Self.duration, delay: 0.0, options: [.curveEaseIn], animations: {
        toView.transform = .identity
        toView.layer.cornerRadius = 0
        fromView.transform = .init(translationX: 0, y: toView.bounds.height)
      }, completion: { _ in

        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })

    } else {
      toView.transform = CGAffineTransform.init(translationX: 0, y: toView.bounds.height)
      toView.layer.cornerRadius = 12
        
      UIView.animate(withDuration: Self.duration, delay: 0.0, options: [.curveEaseOut], animations: {
        fromView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        fromView.layer.cornerRadius = 12
        toView.transform = CGAffineTransform.init(translationX: 0, y: 70)
      }, completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

        // preserve the fromView
        containerView.insertSubview(fromView, belowSubview: toView)
      })

      containerView.addSubview(fromView)
      containerView.addSubview(toView)
    }
  }
}
