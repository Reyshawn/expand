//
//  ShrinkInteractionController.swift
//  expand
//
//  Created by reshawn on 2022/12/21.
//

import UIKit

class ShrinkInteractionController: UIPercentDrivenInteractiveTransition {
  var interactionInProgress = false

  private var shouldCompleteTransition = false
  private weak var viewController: UIViewController!
  
  init(vc: UIViewController) {
    super.init()
    self.viewController = vc
    prepareGestureRecognizer(in: self.viewController.view)
  }
  
  private func prepareGestureRecognizer(in view: UIView) {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
    pan.minimumNumberOfTouches = 1
    pan.maximumNumberOfTouches = 1
    view.addGestureRecognizer(pan)
  }
  
  @objc func onPan(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: viewController.view)
    let progress = max(0, min(1, translation.y / viewController.view.bounds.height))
    
    switch gesture.state {
      case .began:
        interactionInProgress = true
        viewController.dismiss(animated: true)
      case .changed:
        update(progress)
      case .cancelled, .ended:
        interactionInProgress = false
        if progress > 0.5 {
            finish()
        } else {
            cancel()
        }
      default:
        break
    }
  }
}
