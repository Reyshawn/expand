//
//  ExpandViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/26.
//

import UIKit

class ExpandViewController: UIViewController {
  @IBOutlet var expandViewCell: ExpandViewCell!
  @IBOutlet var expandViewCellHeightConstraint: NSLayoutConstraint!
  
  
  override func loadView() {
    view = Bundle.main.loadNibNamed("ExpandView", owner: self)?.first as! UIView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        
    expandViewCell.addGestureRecognizer(tap)
  }
  
  @objc func onTap() {
      let duration: CFTimeInterval = 0.4
      
      let willOpen = self.expandViewCellHeightConstraint.constant == 50
      
      if (willOpen) {
        expandViewCell.showImage(duration)
      } else {
        expandViewCell.hideImage(duration)
      }
      
      
      UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
        self?.expandViewCellHeightConstraint.constant = willOpen ? 200 : 50
        self?.view.layoutIfNeeded()
      } completion: { _ in
      }
      
      CATransaction.begin()
      let animation = CABasicAnimation(keyPath: "shadowOpacity")
      animation.fromValue = self.expandViewCell.layer.shadowOpacity
      animation.toValue = willOpen ? 0.5 : 0
      animation.duration = duration
      self.expandViewCell.layer.add(animation, forKey: animation.keyPath)
      CATransaction.setCompletionBlock { [weak self] in
        self?.expandViewCell.layer.shadowOpacity = willOpen ? 0.5 : 0
      }
      
      CATransaction.commit()
    }
  
}
