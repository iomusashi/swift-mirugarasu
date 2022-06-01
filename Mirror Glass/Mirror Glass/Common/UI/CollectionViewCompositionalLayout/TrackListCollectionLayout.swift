//
//  TrackListCollectionLayout.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import UIKit

final class TrackListCollectionLayout {
  func createLayout() -> UICollectionViewCompositionalLayout {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 16
    
    return UICollectionViewCompositionalLayout(
      sectionProvider: sectionProvider(),
      configuration: config
    )
  }
  
  func sectionProvider() -> (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
    return { _, layoutEnvironment -> NSCollectionLayoutSection? in
      var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
      configuration.showsSeparators = false
      configuration.backgroundColor = .clear
      let section = NSCollectionLayoutSection.list(
        using: configuration,
        layoutEnvironment: layoutEnvironment
      )
      section.contentInsets = NSDirectionalEdgeInsets(
        top: 8,
        leading: 16,
        bottom: 8,
        trailing: 16
      )
      return section
    }
  }
}
