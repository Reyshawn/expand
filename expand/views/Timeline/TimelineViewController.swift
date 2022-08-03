//
//  TimelineViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/23.
//

import UIKit

class TimelineViewController: UIViewController {
   
  lazy var expandAnimation: ExpandAnimation = {
    ExpandAnimation(parent: self.view)
  }()
  
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
    
    let converted = collectionView.convert(cell.frame, to: expandAnimation.parent)
    
    expandAnimation.expand(converted) { size in
      let v = TextCell(frame: size)
      v.configure(item.title, isExpanded: false)
      return v
    }
    
  }
}
