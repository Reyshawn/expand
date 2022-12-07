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
    
    self.view.backgroundColor = .white
    
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
    
    vc.modalPresentationStyle = .fullScreen
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

extension PresentFirstViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    shrinkAnimator = ShrinkAnimator()
    return shrinkAnimator
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    shrinkAnimator?.forDismissed = true
    
    return shrinkAnimator
  }
}
