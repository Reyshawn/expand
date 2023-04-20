//
//  PresentSecondViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/9/27.
//

import UIKit

class PresentSecondViewController: UIViewController {
  private let testLabel: UILabel = {
    let v = UILabel()
    
    v.text = "test"
    v.sizeToFit()
    v.isUserInteractionEnabled = true
    
    v.layer.borderColor = UIColor.red.cgColor
    v.layer.borderWidth = 1
    return v
  }()
  
  override func loadView() {
    view = UIView()
    self.view.backgroundColor = .yellow
    
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.view.addSubview(testLabel)
    testLabel.frame = CGRect(x: 100, y: 100, width: testLabel.frame.width, height: testLabel.frame.height)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTest))
    
    testLabel.addGestureRecognizer(tap)
  }
  
  @objc func onTest() {
    dismiss(animated: true)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  deinit {
    print("deallocate present second")
  }
}
