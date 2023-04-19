//
//  PageSheetPresentationController.swift
//  expand
//
//  Created by Reyshawn Chang on 2023/4/19.
//

import UIKit

class PageSheetPresentationController: UIPresentationController {
  let screenSize: CGSize

  
  init(initialSize: CGSize, presented: UIViewController, presenting: UIViewController?) {
    self.screenSize = initialSize
    super.init(presentedViewController: presented, presenting: presenting)
  }
  
  
  override var frameOfPresentedViewInContainerView: CGRect {
    
    print("screenSize::", screenSize)
    
    
    return CGRect(x: 0, y: screenSize.height / 2, width: screenSize.width, height: screenSize.height / 2)
  }
  
  override func containerViewWillLayoutSubviews() {
    self.presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  override func presentationTransitionWillBegin() {
    let fromVC = self.presentingViewController
    let toVC = self.presentedViewController
    let transitionCoordinator = fromVC.transitionCoordinator
    
    let fromView = transitionCoordinator!.view(forKey: .from)!
    let toView = transitionCoordinator!.view(forKey: .to)!
    
    containerView?.addSubview(fromView)
    containerView?.addSubview(toView)
    
    toView.transform = .init(translationX: 0, y: screenSize.height / 2)
    // fromView.layer.cornerRadius = 45
    fromView.transform = .identity
    
    print("view:::", fromView)
    
    
    print("container frame", self.containerView?.frame)
    
     transitionCoordinator?.animate(alongsideTransition: { context in

       // fromView.transform = .init(translationX: 50, y: 0)
       fromView.transform = .init(scaleX: 0.9, y: 0.9)
       // fromView.layer.cornerRadius = 12
       toView.transform = .identity
     }, completion: { _ in
       print("container frame 123", self.containerView?.frame)
     })
    
    
  }
  
  
  // override func presentationTransitionDidEnd(_ completed: Bool) {
  //   print("completed:::", completed)
  //   let fromVC = self.presentingViewController
  //   let toVC = self.presentedViewController
  //   let fromView = fromVC.view!
  //
  //
  //   fromView.transform = .init(scaleX: 0.4, y: 1)
  //
  //
  //
  // }
  
  override var shouldPresentInFullscreen: Bool {
    return false
  }
}
