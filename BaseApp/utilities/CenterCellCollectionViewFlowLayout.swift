//
//  CenterCellCollectionViewFlowLayout.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/11/2024.
//

import Foundation
import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return AppLanguage.isArabic()
    }
    
   var mostRecentOffset : CGPoint = CGPoint()
   override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
       if velocity.x == 0 {
           return mostRecentOffset
       }
       if let cv = self.collectionView {
           let cvBounds = cv.bounds
           let halfWidth = cvBounds.size.width * 0.5;

           if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
               var candidateAttributes : UICollectionViewLayoutAttributes?
               for attributes in attributesForVisibleCells {
                   if attributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                       continue
                   }
                   if (attributes.center.x == 0) || (attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0) {
                       continue
                   }
                   candidateAttributes = attributes
               }
               if(proposedContentOffset.x == -(cv.contentInset.left)) {
                   return proposedContentOffset
               }
               guard let _ = candidateAttributes else {
                   return mostRecentOffset
               }
               mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
               return mostRecentOffset
           }
       }
       mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
       return mostRecentOffset
   }

}
extension UICollectionView {
    func scrollToCenteredItem(at indexPath: IndexPath, animated: Bool) {
        guard let layout = self.collectionViewLayout as? CenterCellCollectionViewFlowLayout,
              let attributes = layout.layoutAttributesForItem(at: indexPath) else {
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
            return
        }
        
        let collectionViewCenter = self.bounds.size.width / 2
        let targetOffsetX = attributes.center.x - collectionViewCenter
        self.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
    }
}
