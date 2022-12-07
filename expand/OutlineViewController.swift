//
//  OutlineViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/26.
//

import UIKit

class OutlineViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  class OutlineItem: Hashable {
    let title: String
    let subitems: [OutlineItem]
    let outlineViewController: UIViewController.Type?

    init(title: String,
         viewController: UIViewController.Type? = nil,
         subitems: [OutlineItem] = []) {
        self.title = title
        self.subitems = subitems
        self.outlineViewController = viewController
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    private let identifier = UUID()
  }
  
  
  var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
  var outlineCollectionView: UICollectionView! = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Outline"
    configureCollectionView()
    configureDataSource()
  }
  
  private lazy var menuItems: [OutlineItem] = {
    return [
      OutlineItem(title: "Expand", viewController: ExpandViewController.self),
      OutlineItem(title: "Timeline", viewController: TimelineViewController.self),
      OutlineItem(title: "Present", viewController: PresentViewController.self)
    ]
  }()
}


extension OutlineViewController {
  func configureCollectionView() {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .systemGroupedBackground
    self.outlineCollectionView = collectionView
    collectionView.delegate = self
  }
  
  func configureDataSource() {
    let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in
      var contentConfiguration = cell.defaultContentConfiguration()
      contentConfiguration.text = menuItem.title
      contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
      cell.contentConfiguration = contentConfiguration
      
      let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
      cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
    }
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in
      var contentConfiguration = cell.defaultContentConfiguration()
      contentConfiguration.text = menuItem.title
      cell.contentConfiguration = contentConfiguration
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
    }
    
    dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: outlineCollectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: OutlineItem) -> UICollectionViewCell? in
      if item.subitems.isEmpty {
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
      } else {
        return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
      }
    }
    
    let snapshot = initialSnapshot()
    self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
  }
  
  func generateLayout() -> UICollectionViewLayout {
    let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
    let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    
    return layout
  }
  
  func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
    var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
    
    func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
      snapshot.append(menuItems, to: parent)
      for menuItem in menuItems where !menuItem.subitems.isEmpty {
        addItems(menuItem.subitems, to: menuItem)
      }
    }
    
    addItems(menuItems, to: nil)
    return snapshot
  }
}


extension OutlineViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }
    
    collectionView.deselectItem(at: indexPath, animated: true)
    
    if let viewController = menuItem.outlineViewController {
      navigationController?.pushViewController(viewController.init(), animated: true)
    }
  }
}
