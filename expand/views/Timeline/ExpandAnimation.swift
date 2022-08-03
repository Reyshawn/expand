//
//  ExpandAnimation.swift
//  expand
//
//  Created by reshawn on 2022/8/3.
//

import UIKit

final class ExpandAnimation {
  let parent: UIView
  
  var initialFrame: CGRect = .zero
  var upSnapshot: UIView? = nil
  var downSnapshot: UIView? = nil
  var expandView: UIView? = nil
  
  lazy var overlay: UIView = {
    let v = UIView(frame: parent.frame)
    v.backgroundColor = UIColor.black
    v.layer.opacity = 0
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(collapse))
    v.addGestureRecognizer(tap)
    return v
  }()
  
  
  var expandHeightConstraint: NSLayoutConstraint? = nil
  var expandTopConstraint: NSLayoutConstraint? = nil
  
  init(parent: UIView) {
    self.parent = parent
  }

  private func constructHierachy() {
    guard let upSnapshot = upSnapshot,
          let downSnapshot = downSnapshot,
          let expandView = expandView else {
      return
    }
    
    self.parent.addSubview(upSnapshot)
    self.parent.addSubview(downSnapshot)
    self.parent.addSubview(overlay)
    self.parent.addSubview(expandView)
  }
  

  private func activateConstraints() {
    guard let upSnapshot = upSnapshot,
          let downSnapshot = downSnapshot,
          let expandView = expandView else {
      return
    }
    
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
  
  private func beginAnimation() {
    guard let downSnapshot = downSnapshot,
          let expandView = expandView else {
      return
    }
    
    
    let duration: CFTimeInterval = 0.8
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      guard let converted = self?.initialFrame else {
        return
      }
      
      self!.expandHeightConstraint!.constant = converted.height + 100
      self!.expandTopConstraint!.constant = converted.minY - 30
      
      downSnapshot.frame = CGRect(
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
      expandView.layer.shadowOpacity = 0.5
    }
    
    CATransaction.commit()
    
  }
  
  func expand(_ frame: CGRect, createExapndView: (CGRect) -> UIView) {
    self.initialFrame = frame
    self.expandView = createExapndView(self.initialFrame)
    
    if let expandView = expandView {
      expandView.backgroundColor = UIColor.white
      expandView.layer.shadowOffset = CGSize(width: 0,
                                        height: 5)
      expandView.layer.shadowRadius = 10
      expandView.layer.shadowOpacity = 0
      expandView.layer.shadowColor = UIColor.black.cgColor
    }
    

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
    
    constructHierachy()
    activateConstraints()
    
    beginAnimation()
  }

  

  @objc func collapse() {
    guard let downSnapshot = downSnapshot,
          let expandView = expandView else {
      return
    }
    
    let duration: CFTimeInterval = 0.8
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      guard let converted = self?.initialFrame else {
        return
      }
      
      self!.expandHeightConstraint!.constant = converted.height
      self!.expandTopConstraint!.constant = converted.minY
      
      downSnapshot.frame = CGRect(
        x: 0,
        y: converted.maxY,
        width: self!.parent.bounds.width,
        height: (self!.parent.bounds.height - converted.maxY))
      self?.parent.layoutIfNeeded()
    } completion: { [weak self]_ in
      self?.upSnapshot?.removeFromSuperview()
      self?.downSnapshot?.removeFromSuperview()
      self?.expandView?.removeFromSuperview()
      
      self?.upSnapshot = nil
      self?.downSnapshot = nil
      self?.expandView = nil
    }
    
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 0.3
    animation.toValue = 0
    animation.duration = 0.4
    
    let shadowAnimatoin = CABasicAnimation(keyPath: "shadowOpacity")
    shadowAnimatoin.fromValue = 0.5
    shadowAnimatoin.toValue = 0
    shadowAnimatoin.duration = 0.4
    overlay.layer.add(animation, forKey: animation.keyPath)
    expandView.layer.add(shadowAnimatoin, forKey: shadowAnimatoin.keyPath)
    CATransaction.setCompletionBlock { [weak self] in
      self!.overlay.layer.opacity = 0
      expandView.layer.shadowOpacity = 0
      self?.overlay.removeFromSuperview()
    }
    
    CATransaction.commit()
  }
}
