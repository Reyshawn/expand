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
    let fromView = transitionContext.viewController(forKey: .from)!.view!
    let toView = transitionContext.viewController(forKey: .to)!.view!

    
    if forDismissed {
      UIView.animate(withDuration: Self.duration, delay: 0.0, options: [.curveEaseIn], animations: {
        toView.transform = .identity
        toView.layer.cornerRadius = 0
        fromView.transform = .init(translationX: 0, y: toView.bounds.height)
      }, completion: { _ in

        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })

    } else {
      
      toView.frame = CGRect(x: 0, y: fromView.frame.height / 2, width: fromView.frame.width, height: fromView.frame.height / 2)
      toView.transform = .init(translationX: 0, y: fromView.frame.height / 2)
      
      // toView.transform = CGAffineTransform.init(translationX: 0, y: toView.bounds.height)
      toView.layer.cornerRadius = 12
        
      UIView.animate(withDuration: Self.duration, delay: 0.0, options: [.curveEaseOut], animations: {
        fromView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        fromView.layer.cornerRadius = 12
        toView.transform = .identity
      }, completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

        // preserve the fromView
        // containerView.insertSubview(fromView, belowSubview: toView)
      })

      // containerView.addSubview(fromView)
      containerView.addSubview(toView)
    }
  }
}
