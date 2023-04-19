//
//  PresentViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/9/26.
//

import UIKit

class PresentViewController: UIViewController {
  
  private let testLabel: UILabel = {
    let v = UILabel()
    
    v.text = "test"
    v.sizeToFit()
    v.isUserInteractionEnabled = true
    return v
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    self.view.addSubview(testLabel)
    testLabel.frame = CGRect(x: 100, y: 100, width: testLabel.frame.width, height: testLabel.frame.height)
    testLabel.layer.borderColor = UIColor.red.cgColor
    testLabel.layer.borderWidth = 1
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTest))
    
    testLabel.addGestureRecognizer(tap)
  }
  
  @objc func onTest () {
    print("test start")
    
    
    let vc = PresentFirstViewController()
    vc.modalPresentationStyle = .fullScreen
    // vc.transitioningDelegate = self
    present(vc, animated: false)
  }
}

