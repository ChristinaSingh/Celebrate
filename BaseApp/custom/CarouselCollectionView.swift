//
// CarouselCollectionView.swift
// InfiniteCarousel
//
// Created by Filipp Fediakov on 13.10.2018.
//

import UIKit

@objc public protocol CarouselCollectionViewDataSource {
    var numberOfItems: Int { get }
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView,
                                cellForItemAt index: Int,
                                fakeIndexPath: IndexPath) -> UICollectionViewCell
    @objc optional func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView,
                                               didSelectItemAt index: Int)
    @objc optional func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView,
                                               didDisplayItemAt index: Int)
}

public class CarouselCollectionView: UICollectionView {
    public weak var carouselDataSource: CarouselCollectionViewDataSource?
    
    let flowLayout: YZCenterFlowLayout
    public var autoscrollTimeInterval: TimeInterval = 5.0
    
    public var isAutoscrollEnabled: Bool = false {
        didSet {
            if isAutoscrollEnabled {
                tryToStartTimer()
            } else {
                stopAutoscrollTimer()
            }
        }
    }
    
    public var currentPage: Int = 0
    
    
    private var hasInitializedFirstPage = false
    private var autoscrollTimer: Timer?
    
    var numberOfItems: Int {
        return carouselDataSource?.numberOfItems ?? 0
    }
    var infiniteMultiplier: Int { return 100 }
    var virtualNumberOfItems: Int {
        return numberOfItems * infiniteMultiplier
    }
    
    public init(frame: CGRect, collectionViewFlowLayout layout: UICollectionViewFlowLayout) {
        flowLayout = layout as! YZCenterFlowLayout
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        isPagingEnabled = false
        flowLayout.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func setCurrentPage(_ page: Int, animated: Bool = false) {
        flowLayout.scrollToPage(atIndex: page)
    }
    
    
    private func notifyDatasourceOnDisplayPage(_ index: Int) {
        carouselDataSource?.carouselCollectionView?(self, didDisplayItemAt: index)
    }
    
    // MARK: - Autoscrolling
    
    private func tryToStartTimer() {
        guard isAutoscrollEnabled else {
            return
        }
        stopAutoscrollTimer()
        autoscrollTimer = Timer.scheduledTimer(withTimeInterval: autoscrollTimeInterval, repeats: false) { [weak self] _ in self?.scrollToNextElement() }
    }
    
    private func stopAutoscrollTimer() {
        autoscrollTimer?.invalidate()
        autoscrollTimer = nil
    }
    
    func scrollToNextElement() {
        guard virtualNumberOfItems > 0 else { return }
        currentPage = (currentPage + 1) % virtualNumberOfItems
        setCurrentPage(currentPage, animated: true)
        notifyDatasourceOnDisplayPage(realIndex(from: currentPage))
        tryToStartTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = flowLayout.currentCenteredPage ?? currentPage
        notifyDatasourceOnDisplayPage(realIndex(from: currentPage))
        tryToStartTimer()
    }
    
}



extension CarouselCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let realIndex = self.realIndex(from: indexPath.row)
        carouselDataSource?.carouselCollectionView?(self, didSelectItemAt: realIndex)
    }
}

extension CarouselCollectionView: UICollectionViewDataSource {
    
    func realIndex(from virtualIndex: Int) -> Int {
        return virtualIndex % numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return virtualNumberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let carouselDataSource = carouselDataSource else {
            assertionFailure()
            return UICollectionViewCell()
        }
        let realIndex = self.realIndex(from: indexPath.row)
        return carouselDataSource.carouselCollectionView(self, cellForItemAt: realIndex, fakeIndexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.flowLayout.minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.flowLayout.minimumInteritemSpacing
    }
}
