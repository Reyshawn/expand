//
//  PresentFirstViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/9/26.
//

import UIKit

class PresentFirstViewController: UIViewController {
  
  private let testLabel: UILabel = {
    let v = UILabel()
    
    v.text = "test"
    v.sizeToFit()
    v.isUserInteractionEnabled = true
    
    v.layer.borderColor = UIColor.red.cgColor
    v.layer.borderWidth = 1
    return v
  }()
  
  private let dismissLabel: UILabel = {
    let v = UILabel()
    
    v.text = "back"
    v.sizeToFit()
    v.isUserInteractionEnabled = true
    
    v.layer.borderColor = UIColor.red.cgColor
    v.layer.borderWidth = 1
    return v
  }()
  
  
  var shrinkAnimator: ShrinkAnimator?
  
  var isDarkBackground: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .cyan
    
    self.view.addSubview(testLabel)
    self.view.addSubview(dismissLabel)
    testLabel.frame = CGRect(x: 100, y: 100, width: testLabel.frame.width, height: testLabel.frame.height)
    
    dismissLabel.frame = CGRect(x: 100, y: 300, width: dismissLabel.frame.width, height: dismissLabel.frame.height)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTest))
    
    testLabel.addGestureRecognizer(tap)
    
    let backTap = UITapGestureRecognizer(target: self, action: #selector(onBack))
    
    dismissLabel.addGestureRecognizer(backTap)
  }
  
  @objc func onTest () {
    let vc = PresentSecondViewController()
    
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = self
    present(vc, animated: true)
  }
  
  @objc func onBack () {
    dismiss(animated: true)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return isDarkBackground ? .lightContent : .darkContent
  }
}


// Transitioning

// extension PresentFirstViewController: UIViewControllerTransitioningDelegate {
//   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//     let interactionController = ShrinkInteractionController(vc: presented)
//     shrinkAnimator = ShrinkAnimator(interactionController: interactionController)
//     return shrinkAnimator
//   }
// 
//   func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//     shrinkAnimator?.forDismissed = true
// 
//     return shrinkAnimator
//   }
// 
//   func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//     guard let animator = animator as? ShrinkAnimator,
//           let interactionController = animator.interactionController,
//           interactionController.interactionInProgress
//     else {
//       return nil
//     }
//     return interactionController
//   }
// }



extension PresentFirstViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
    
    let screenSize = self.view.window?.screen.bounds.size ?? .zero
    print("screenSize:::123123", screenSize)
    return PageSheetPresentationController(initialSize: screenSize, presented: presented, presenting: presenting)
  }
}
