//
//  ExpandViewController.swift
//  expand
//
//  Created by reshawn on 2022/7/20.
//

import UIKit

class ExpandViewController: UIViewController {
  
  @IBOutlet var expandViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet var expandView: ExpandView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
    
 
    expandView.addGestureRecognizer(tap)
  }
  
  
  @objc func onTap() {
    let duration: CFTimeInterval = 0.4
    
    let willOpen = self.expandViewWidthConstraint.constant == 50
    
    if (willOpen) {
      expandView.showImage(duration)
    } else {
      expandView.hideImage(duration)
    }
    
    
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      self?.expandViewWidthConstraint.constant = willOpen ? 200 : 50
      self?.view.layoutIfNeeded()
    } completion: { _ in
    }
    
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "shadowOpacity")
    animation.fromValue = self.expandView.layer.shadowOpacity
    animation.toValue = willOpen ? 0.5 : 0
    animation.duration = duration
    self.expandView.layer.add(animation, forKey: animation.keyPath)
    CATransaction.setCompletionBlock { [weak self] in
      self?.expandView.layer.shadowOpacity = willOpen ? 0.5 : 0
    }
    
    CATransaction.commit()
  }
}

