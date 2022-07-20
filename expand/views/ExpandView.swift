//
//  ExpandView.swift
//  expand
//
//  Created by reshawn on 2022/7/20.
//

import UIKit

class ExpandView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadNib()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.backgroundColor = .white
    // self.layer.borderColor = UIColor.cyan.cgColor
    // self.layer.borderWidth = 1
    
    self.layer.shadowOffset = CGSize(width: 0,
                                      height: 5)
    self.layer.shadowRadius = 10
    self.layer.shadowOpacity = 0
    self.layer.shadowColor = UIColor.black.cgColor
    
    loadNib()
  }
  
  func loadNib() {
    let xib = Bundle.main.loadNibNamed("ExpandView", owner: self)?.first as! UIView
    addSubview(xib)
    
    xib.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xib.topAnchor.constraint(equalTo: self.topAnchor),
      xib.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      xib.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      xib.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
