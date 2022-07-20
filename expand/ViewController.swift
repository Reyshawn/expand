//
//  ViewController.swift
//  expand
//
//  Created by reshawn on 2022/7/20.
//

import UIKit

class ViewController: UIViewController {
  
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
    
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      self?.expandViewWidthConstraint.constant = self?.expandViewWidthConstraint.constant == 50 ? 200 : 50
      self?.view.layoutIfNeeded()
    } completion: { _ in
    }
    
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "shadowOpacity")
    animation.fromValue = self.expandView.layer.shadowOpacity
    animation.toValue = self.expandView.layer.shadowOpacity == 0 ? 0.5 : 0
    animation.duration = duration
    self.expandView.layer.add(animation, forKey: animation.keyPath)
    CATransaction.setCompletionBlock { [weak self] in
      self?.expandView.layer.shadowOpacity = self?.expandView.layer.shadowOpacity == 0 ? 0.5 : 0
    }
    
    CATransaction.commit()
  }
}

