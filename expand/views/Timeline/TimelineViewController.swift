//
//  TimelineViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/23.
//

import UIKit

class TimelineViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  class TimelineItem: Hashable {
    private let id = UUID()
    let title: String
    let subitems: [TimelineItem]
    var isExpanded: Bool = false
    
    init(title: String, subitems:[TimelineItem] = []) {
      self.title = title
      self.subitems = subitems
    }
    
    static func == (lhs: TimelineViewController.TimelineItem, rhs: TimelineViewController.TimelineItem) -> Bool {
      return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(self.id)
    }
  }
  
  private lazy var items:[TimelineItem] = {
    return [
      TimelineItem(title: "2022", subitems: [
        TimelineItem(title: "Jul.", subitems: [
          TimelineItem(title: "17th 西部世界：第四季 适应还是死亡 第 4 集"),
          TimelineItem(title: "24th 西部世界：第四季 适应还是死亡 第 5 集"),
          TimelineItem(title: "31st 西部世界：第四季 适应还是死亡 第 6 集 ****")
        ]),
        TimelineItem(title: "Aug.", subitems: [
          TimelineItem(title: "7th 西部世界：第四季 适应还是死亡 第 7 集"),
          TimelineItem(title: "14th 西部世界：第四季 适应还是死亡 第 8 集")
        ]),
        TimelineItem(title: "Nov.", subitems: [
          TimelineItem(title: "11th 铃芽户缔 すずめの戸締まり")
        ])
      ]),
      TimelineItem(title: "2023", subitems: [
      ])
    ]
  }()
  
  var dataSource: UICollectionViewDiffableDataSource<Section, TimelineItem>! = nil
  var collectionView: UICollectionView! = nil
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Timeline"
    configureHierachy()
    configureDataSource()
  }
}


extension TimelineViewController {
  private func createLayout() -> UICollectionViewLayout {
    let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
    let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    
    return layout
  }
}

extension TimelineViewController {
  private func configureHierachy() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    collectionView.delegate = self
  }
  
  private func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<TextCell, TimelineItem> { (cell, indexPath, item) in
      cell.configure(item.title, isExpanded: item.isExpanded)
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: TimelineItem) -> UICollectionViewCell? in
      
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    let snapshot = initialSnapshot()
    
    dataSource.apply(snapshot, to: .main, animatingDifferences: false)
  }
  
  
  func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<TimelineItem> {
    var snapshot = NSDiffableDataSourceSectionSnapshot<TimelineItem>()
    
    func addItems(_ items: [TimelineItem], to parent: TimelineItem?) {
      snapshot.append(items, to: parent)
      for item in items where !item.subitems.isEmpty {
        addItems(item.subitems, to: parent)
      }
    }
    
    addItems(items, to: nil)
    return snapshot
  }
}

extension TimelineViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as? TextCell else {
      return
    }
    
    let item = dataSource.itemIdentifier(for: indexPath)!
    
    let converted = collectionView.convert(cell.frame, to: self.view)
    let upSnapshot = self.view.resizableSnapshotView(
      from: CGRect(
        x: 0,
        y: 0,
        width: self.view.bounds.width,
        height: converted.minY),
      afterScreenUpdates: false, withCapInsets: .zero)!
    
    let downSnapshot = self.view.resizableSnapshotView(
      from: CGRect(
        x: 0,
        y: converted.maxY,
        width: self.view.bounds.width,
        height: (self.view.bounds.height - converted.maxY)),
      afterScreenUpdates: false, withCapInsets: .zero)!
  
     
    downSnapshot.frame = CGRect(
      x: 0,
      y: converted.maxY,
      width: self.view.bounds.width,
      height: (self.view.bounds.height - converted.maxY))
    
    // collectionView.isHidden = true
    self.view.addSubview(upSnapshot)
    self.view.addSubview(downSnapshot)
    
    
    let overlay = UIView(frame: self.view.frame)
    overlay.backgroundColor = UIColor.black
    overlay.layer.opacity = 0
    
    self.view.addSubview(overlay)
    
    // create a TextCell
    
    let textCell = TextCell(frame: converted)
    textCell.configure(item.title, isExpanded: false)

    textCell.backgroundColor = UIColor.white
    
    textCell.layer.shadowOffset = CGSize(width: 0,
                                      height: 5)
    textCell.layer.shadowRadius = 10
    textCell.layer.shadowOpacity = 0
    textCell.layer.shadowColor = UIColor.black.cgColor
    
    self.view.addSubview(textCell)
    
    
    upSnapshot.translatesAutoresizingMaskIntoConstraints = false
    downSnapshot.translatesAutoresizingMaskIntoConstraints = false
    textCell.translatesAutoresizingMaskIntoConstraints = false
    
    var textCellHeightConstraint = textCell.heightAnchor.constraint(equalToConstant: converted.height)
    var textCellTopConstraint = textCell.topAnchor.constraint(equalTo: self.view.topAnchor, constant: converted.minY)
    
    NSLayoutConstraint.activate([
      textCell.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      textCell.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      textCellHeightConstraint,
      textCellTopConstraint,
      
      upSnapshot.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      upSnapshot.bottomAnchor.constraint(equalTo: textCell.topAnchor, constant: 0),
      upSnapshot.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      upSnapshot.heightAnchor.constraint(equalToConstant: converted.minY)
    ])
    

    let duration: CFTimeInterval = 0.8
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut]) { [weak self] in
      textCellHeightConstraint.constant = converted.height + 100
      textCellTopConstraint.constant = converted.minY - 30
      
      downSnapshot.frame = CGRect(
        x: 0,
        y: converted.maxY + 100 - 30,
        width: self!.view.bounds.width,
        height: (self!.view.bounds.height - converted.maxY))
      self?.view.layoutIfNeeded()
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
    textCell.layer.add(shadowAnimatoin, forKey: shadowAnimatoin.keyPath)
    CATransaction.setCompletionBlock { [weak self] in
      overlay.layer.opacity = 0.3
      textCell.layer.shadowOpacity = 0.5
    }
    
    CATransaction.commit()
  }
}
