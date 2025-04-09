//
//  UICollectionView+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/04/2024.
//

import Foundation
import UIKit

extension UICollectionView {
    func canScrollToItem(at indexPath: IndexPath) -> Bool {
        let visibleIndexPaths = indexPathsForVisibleItems
        return !visibleIndexPaths.contains(indexPath)
    }
    

    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item < numberOfItems(inSection: indexPath.section) else {
            return
        }
        if canScrollToItem(at: indexPath) {
            scrollToItem(at: indexPath, at: .top, animated: animated)
            if layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) != nil {
                let topOffset = CGPoint(x: 0, y: 0)
                setContentOffset(topOffset, animated: true)
            }
        }
        
    }

}

