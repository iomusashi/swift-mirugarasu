//
//  CardsCollectionViewLayout.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/2/22.
//

import UIKit

open class CardsCollectionViewLayout: UICollectionViewLayout {
  public var itemSize: CGSize = CGSize(width: 300, height: 374) {
    didSet {
      invalidateLayout()
    }
  }
  
  public var spacing: CGFloat = 98.0 {
    didSet {
      invalidateLayout()
    }
  }
  
  public var maximumVisibleItems: Int = 4 {
    didSet {
      invalidateLayout()
    }
  }
  
  public var isRotated = false
  
  override open var collectionView: UICollectionView {
    return super.collectionView!
  }
  
  override open var collectionViewContentSize: CGSize {
    let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
    return CGSize(width: collectionView.bounds.width,
                  height: collectionView.bounds.height * itemsCount)
  }
  
  override open func prepare() {
    super.prepare()
    collectionView.transform =
    CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
    assert(collectionView.numberOfSections == 1, "Multiple sections aren't supported!")
  }
  
  override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let totalItemsCount = collectionView.numberOfItems(inSection: 0)
    
    let minVisibleIndex = max(Int(collectionView.contentOffset.y) / Int(collectionView.bounds.height), 0)
    let maxVisibleIndex = min(minVisibleIndex + maximumVisibleItems, totalItemsCount)
    
    let contentCenterY = collectionView.contentOffset.y + (collectionView.bounds.height / 2.0) - 24
    
    let deltaOffset = Int(collectionView.contentOffset.y) % Int(collectionView.bounds.height)
    
    let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.height
    
    let visibleIndices = stride(from: minVisibleIndex, to: maxVisibleIndex, by: 1)
    
    let attributes: [UICollectionViewLayoutAttributes] = visibleIndices.map { index in
      let indexPath = IndexPath(item: index, section: 0)
      return computeLayoutAttributesForItem(indexPath: indexPath,
                                            minVisibleIndex: minVisibleIndex,
                                            contentCenterY: contentCenterY,
                                            deltaOffset: CGFloat(deltaOffset),
                                            percentageDeltaOffset: percentageDeltaOffset)
    }
    
    return attributes
  }
  
  override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let contentCenterY = collectionView.contentOffset.y + (collectionView.bounds.height / 2.0)
    let minVisibleIndex = Int(collectionView.contentOffset.y) / Int(collectionView.bounds.height)
    let deltaOffset = Int(collectionView.contentOffset.y) % Int(collectionView.bounds.height)
    let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.height
    return computeLayoutAttributesForItem(indexPath: indexPath,
                                          minVisibleIndex: minVisibleIndex,
                                          contentCenterY: contentCenterY,
                                          deltaOffset: CGFloat(deltaOffset),
                                          percentageDeltaOffset: percentageDeltaOffset)
  }
  
  override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}

// MARK: - Layout computations
fileprivate extension CardsCollectionViewLayout {
  
  private func scale(at index: Int) -> CGFloat {
    let translatedCoefficient = CGFloat(index) - CGFloat(self.maximumVisibleItems) / 2
    return CGFloat(pow(1.0, translatedCoefficient))
  }
  
  private func transform(atCurrentVisibleIndex visibleIndex: Int, percentageOffset: CGFloat) -> CGAffineTransform {
    var rawScale = visibleIndex < maximumVisibleItems ? scale(at: visibleIndex) : 1.0
    
    if visibleIndex != 0 {
      let previousScale = scale(at: visibleIndex - 1)
      let delta = (previousScale - rawScale) * percentageOffset
      rawScale += delta
    }
    if isRotated {
      return CGAffineTransform(rotationAngle: .pi)
    } else {
      return CGAffineTransform(scaleX: rawScale, y: rawScale)
    }
  }
  
  func computeLayoutAttributesForItem(indexPath: IndexPath,
                                      minVisibleIndex: Int,
                                      contentCenterY: CGFloat,
                                      deltaOffset: CGFloat,
                                      percentageDeltaOffset: CGFloat) -> UICollectionViewLayoutAttributes {
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let visibleIndex = indexPath.row - minVisibleIndex
    attributes.size = itemSize
    let midX = self.collectionView.bounds.midX
    attributes.center = CGPoint(x: midX + spacing * CGFloat(visibleIndex),
                                y: contentCenterY + spacing * CGFloat(visibleIndex))
    attributes.zIndex = maximumVisibleItems - visibleIndex
    
    attributes.transform = transform(atCurrentVisibleIndex: visibleIndex,
                                     percentageOffset: percentageDeltaOffset)
    switch visibleIndex {
    case 0:
      attributes.center.y -= deltaOffset
      
    case 1..<maximumVisibleItems:
      attributes.center.x = midX
      attributes.center.y -= spacing * percentageDeltaOffset
      
      
      if visibleIndex == maximumVisibleItems - 1 {
        attributes.alpha = percentageDeltaOffset
      }
      
    default:
      attributes.alpha = 0
    }
    return attributes
  }
}
