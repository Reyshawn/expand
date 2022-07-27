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
  
  var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
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
    let layout = UICollectionViewCompositionalLayout {
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      let leadingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.7),
          heightDimension: .fractionalHeight(1.0)))
      
      leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      let trailingItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(0.3)))
      
      trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      let trailingGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)),
        subitem: trailingItem, count: 2)
      
      let nestedGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4)),
        subitems: [leadingItem, trailingGroup])
      
      let section = NSCollectionLayoutSection(group: nestedGroup)
      
      return section
    }
    
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
    let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, itemIdentifier) in
      cell.label.text = "\(indexPath.section), \(indexPath.item)"
      cell.contentView.backgroundColor = .cyan
      cell.contentView.layer.borderColor = UIColor.black.cgColor
      cell.contentView.layer.borderWidth = 1
      cell.contentView.layer.cornerRadius = 8
      cell.label.textAlignment = .center
      cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Int) -> UICollectionViewCell? in
      
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
      
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    snapshot.appendSections([Section.main])
    snapshot.appendItems(Array(0..<100))
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension TimelineViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}
