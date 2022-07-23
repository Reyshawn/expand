//
//  TimelineViewController.swift
//  expand
//
//  Created by Reyshawn Chang on 2022/7/23.
//

import UIKit

class TimelineViewController: UIViewController {
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { index, _ in
      let supplementaryViews = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top)
      ]
      
      switch index {
        case 1:
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalHeight(1.0)
            )
          )
          
          item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalWidth(0.7 / 1.5)),
            subitems: [item]
          )
          
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = .continuous
          
          section.boundarySupplementaryItems = supplementaryViews
          
          return section
        default:
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalHeight(1.0)
            )
          )
          
          item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4 * 1.5)),
            subitems: [item]
          )
          
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = .continuous
          
          section.boundarySupplementaryItems = supplementaryViews
          
          return section
      }
    }
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return view
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(collectionView)
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
  }
}


extension TimelineViewController: UICollectionViewDelegate {
  
}


extension TimelineViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    3
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.contentView.backgroundColor = .blue
    
    return cell
  }
  

}
