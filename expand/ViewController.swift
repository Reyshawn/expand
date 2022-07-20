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
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      self?.expandViewWidthConstraint.constant = self?.expandViewWidthConstraint.constant == 100 ? 200 : 100
      self?.view.layoutIfNeeded()
    } completion: { _ in
    }
  }
  
}

