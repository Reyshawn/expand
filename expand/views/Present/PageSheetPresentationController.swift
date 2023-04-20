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
    return CGRect(x: 0, y: screenSize.height / 2, width: screenSize.width, height: screenSize.height / 2)
  }
  
  override func containerViewWillLayoutSubviews() {
    self.presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  override func presentationTransitionWillBegin() {
    
  }
  
  override func dismissalTransitionWillBegin() {

  }
  
  
  override func dismissalTransitionDidEnd(_ completed: Bool) {
    print("dismiss transition end")
  }
  
  override var shouldPresentInFullscreen: Bool {
    return false
  }
  
  override var shouldRemovePresentersView: Bool {
    return false
  }
}
