//
//  ExpandAnimation.swift
//  expand
//
//  Created by reshawn on 2022/8/3.
//

import UIKit

final class ExpandAnimation {
  let parent: UIView
  let tappedView: UIView
  let initialFrame: CGRect
  let upSnapshot: UIView
  let downSnapshot: UIView
  let expandView: UIView
  
  let overlay: UIView
  
  var expandHeightConstraint: NSLayoutConstraint? = nil
  var expandTopConstraint: NSLayoutConstraint? = nil
  
  init(parent: UIView, tapped: UIView, expand: UIView) {
    self.parent = parent
    self.tappedView = tapped
    self.initialFrame = tapped.superview!.convert(tapped.frame, to: parent)
    self.expandView = expand
    
    expandView.backgroundColor = UIColor.white
    
    expandView.layer.shadowOffset = CGSize(width: 0,
                                      height: 5)
    expandView.layer.shadowRadius = 10
    expandView.layer.shadowOpacity = 0
    expandView.layer.shadowColor = UIColor.black.cgColor
    
    self.upSnapshot = parent.resizableSnapshotView(
      from: CGRect(
        x: 0,
        y: 0,
        width: parent.bounds.width,
        height: self.initialFrame.minY),
      afterScreenUpdates: false, withCapInsets: .zero)!
    
    self.downSnapshot = parent.resizableSnapshotView(
      from: CGRect(
        x: 0,
        y: self.initialFrame.maxY,
        width: parent.bounds.width,
        height: (parent.bounds.height - self.initialFrame.maxY)),
      afterScreenUpdates: false, withCapInsets: .zero)!
    
    
    self.overlay = UIView(frame: parent.frame)
    overlay.backgroundColor = UIColor.black
    overlay.layer.opacity = 0
    
    constructHierachy()
    activateConstraints()
    
    // tapped.superview?.isHidden = true
    self.expand()
  }
  
  
  private func constructHierachy() {
    self.parent.addSubview(self.upSnapshot)
    self.parent.addSubview(self.downSnapshot)
    self.parent.addSubview(self.overlay)
    self.parent.addSubview(self.expandView)
  }
  
  private func activateConstraints() {
    upSnapshot.translatesAutoresizingMaskIntoConstraints = false
    downSnapshot.translatesAutoresizingMaskIntoConstraints = false
    expandView.translatesAutoresizingMaskIntoConstraints = false
    
    expandHeightConstraint = expandView.heightAnchor.constraint(equalToConstant: self.initialFrame.height)
    expandTopConstraint = expandView.topAnchor.constraint(equalTo: parent.topAnchor, constant: self.initialFrame.minY)
    
    NSLayoutConstraint.activate([
      expandView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0),
      expandView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0),
      expandHeightConstraint!,
      expandTopConstraint!,
      
      upSnapshot.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0),
      upSnapshot.bottomAnchor.constraint(equalTo: expandView.topAnchor, constant: 0),
      upSnapshot.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0),
      upSnapshot.heightAnchor.constraint(equalToConstant: self.initialFrame.minY)
    ])
    
    // position downSnapshot
    
    downSnapshot.frame = CGRect(
      x: 0,
      y: self.initialFrame.maxY,
      width: parent.bounds.width,
      height: (parent.bounds.height - self.initialFrame.maxY))
    
  }
  
  func expand() {
    let duration: CFTimeInterval = 0.8
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      guard let converted = self?.initialFrame else {
        return
      }
      
      self!.expandHeightConstraint!.constant = converted.height + 100
      self!.expandTopConstraint!.constant = converted.minY - 30
      
      self!.downSnapshot.frame = CGRect(
        x: 0,
        y: converted.maxY + 100 - 30,
        width: self!.parent.bounds.width,
        height: (self!.parent.bounds.height - converted.maxY))
      self?.parent.layoutIfNeeded()
    } completion: { _ in
    }
    
    
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 0
    animation.toValue = 0.3
    animation.duration = 0.4
    
    let shadowAnimatoin = CABasicAnimation(keyPath: "shadowOpacity")
    shadowAnimatoin.fromValue = 0
    shadowAnimatoin.toValue = 0.5
    shadowAnimatoin.duration = 0.4
    overlay.layer.add(animation, forKey: animation.keyPath)
    expandView.layer.add(shadowAnimatoin, forKey: shadowAnimatoin.keyPath)
    CATransaction.setCompletionBlock { [weak self] in
      self!.overlay.layer.opacity = 0.3
      self!.expandView.layer.shadowOpacity = 0.5
    }
    
    CATransaction.commit()
    
  }
  
  
  func collapse() {
    
  }
  
  
  
}
