//
//  TextCell.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/27.
//

import UIKit

class TextCell: UICollectionViewCell {
  let label = UILabel()
  static let reuseIdentifier = "text-cell-reuse-identifier"
  

  lazy var expandViewCellHeightConstraint: NSLayoutConstraint = {
    var constraint = contentView.heightAnchor.constraint(equalToConstant: 44)
    constraint.priority = .defaultHigh
    return constraint
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError("not implemnted")
  }
}

extension TextCell {
  func configure() {
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    contentView.addSubview(label)
    label.font = UIFont.preferredFont(forTextStyle: .body)
    let inset = CGFloat(10)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    ])
    
    expandViewCellHeightConstraint.isActive = true
  }
  
  func configure(_ text: String, isExpanded: Bool) {
    label.text = text
  
    expandViewCellHeightConstraint.constant = isExpanded ? 100 : 44
    label.numberOfLines = isExpanded ? 0 : 1
  }
}
