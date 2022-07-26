//
//  ExpandViewCell.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/26.
//

import UIKit

class ExpandViewCell: UIView {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var labelLeadingConstraint: NSLayoutConstraint!

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
    
    imageView.image = UIImage(named: "westworld")
    imageView.isHidden = true
    imageView.transform = CGAffineTransform(translationX: -200, y: 0)
  }
  
  func loadNib() {
    let xib = Bundle.main.loadNibNamed("ExpandViewCell", owner: self)?.first as! UIView
    addSubview(xib)
    
    xib.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      xib.topAnchor.constraint(equalTo: self.topAnchor),
      xib.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      xib.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      xib.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
  
  public func showImage(_ duration: CFTimeInterval) {
    imageView.isHidden = false
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      self?.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
      self?.labelLeadingConstraint.constant = 140
      self?.layoutIfNeeded()
    } completion: { _ in
    }
  }
  
  public func hideImage(_ duration: CFTimeInterval) {
    imageView.isHidden = false
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      self?.imageView.transform = CGAffineTransform(translationX: -200, y: 0)
      self?.labelLeadingConstraint.constant = 10
      self?.layoutIfNeeded()
    } completion: { [weak self] _ in
      self?.imageView.isHidden = true
    }
  }
}
