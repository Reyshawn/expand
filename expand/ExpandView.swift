//
//  ExpandView.swift
//  expand
//
//  Created by reshawn on 2022/7/20.
//

import UIKit

class ExpandView: UIView {
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("init:::")
    
    self.backgroundColor = .white
    // self.layer.borderColor = UIColor.cyan.cgColor
    // self.layer.borderWidth = 1
    
    self.layer.shadowOffset = CGSize(width: 0,
                                      height: 5)
    self.layer.shadowRadius = 10
    self.layer.shadowOpacity = 0
    self.layer.shadowColor = UIColor.black.cgColor
  }
}
