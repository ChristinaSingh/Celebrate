//
//  OrderSummeryCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import Foundation
import UIKit
import SnapKit

protocol OrderSummeryCellDelegate: AnyObject {
    func didTapPayNow()
}

class OrderSummeryCell:UITableViewCell, PendingApprovalItemSummeryDelegate {
    weak var delegate: OrderSummeryCellDelegate? // Delegate reference to HomeViewController

    
    private lazy var collectionView:UICollectionView = {
        let layout = YZCenterFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 16)
        var animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0, sideItemAlpha: 0, sideItemShift: 0.0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PendingApprovalItemSummery.self, forCellWithReuseIdentifier: PendingApprovalItemSummery.identifier)
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl:UIPageControl = {
        let page = UIPageControl()
        page.tintColor = .white.withAlphaComponent(0.25)
        page.pageIndicatorTintColor = .white.withAlphaComponent(0.25)
        page.currentPageIndicatorTintColor = .white
        return page
    }()
    
    var order: Cart? {
        didSet{
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = order?.items?.count ?? 0
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapPayNow() {
        delegate?.didTapPayNow() // Forward event to HomeViewController
    }
    
    private func setup(){
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(collectionView)
        self.contentView.addSubview(pageControl)
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(150)
        }
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
    }
}

extension OrderSummeryCell{
    @objc func autoScroll() {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if let firstItem = visibleItems.first {
            let nextItem = IndexPath(item: firstItem.item + 1, section: 0)
            collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
            updatePageControl()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl()
    }
    
    func updatePageControl() {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pageControl.currentPage = indexPath.item
    }
}

extension OrderSummeryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PendingApprovalItemSummery.identifier, for: indexPath) as! PendingApprovalItemSummery
        cell.titleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 18)
        cell.titleLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        cell.orderDateTitleLbl.text = "Order date".localized
        cell.deliveryDateTitleLbl.text = "Delivery date".localized
        cell.statusTtitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        cell.orderDateTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        cell.orderDateLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        cell.deliveryDateTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        cell.deliveryDateLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        cell.statusTtitleLbl.text = self.order?.items?.get(at: indexPath.row)?.pendingItemStatus?.getStatus() ?? "Pending".localized
        cell.titleLbl.text = "\(AppLanguage.isArabic() ? self.order?.items?.get(at: indexPath.row)?.product?.arName ?? "" : self.order?.items?.get(at: indexPath.row)?.product?.name ?? "")"
        if let date = parseDate(from: self.order?.warnTime?.date ?? "", format: "yyyy-MM-dd HH:mm:ss.SSSSSS") {
            let formattedDateString = formatDate(date, toFormat: "dd, MMM yyyy")
            cell.orderDateLbl.text = formattedDateString
        } else {
            cell.orderDateLbl.text = self.order?.warnTime?.date ?? ""
        }
        if let date = parseDate(from: self.order?.deliveryDate ?? "", format: "yyyy-MM-dd") {
            let formattedDateString = formatDate(date, toFormat: "dd, MMM yyyy")
            cell.deliveryDateLbl.text = formattedDateString
        } else {
            cell.deliveryDateLbl.text = self.order?.deliveryDate ?? ""
        }
        switch self.order?.items?.get(at: indexPath.row)?.pendingItemStatus {
        case .approved_by_client, .pending:
            cell.payNowBtn.setTitle("Waiting".localized)
            cell.payNowBtn.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
            cell.payNowBtn.backgroundColor = .clear //UIColor(named: "AccentColor")
            cell.progressBar.stripesColor = .systemOrange
            break
        case .approved, .readyToPay:
            cell.payNowBtn.setTitle("Pay Now".localized)
            cell.payNowBtn.setTitleColor(UIColor(named: "White"), for: .normal)
            cell.payNowBtn.backgroundColor = UIColor(named: "AccentColor")
            cell.progressBar.stripesColor = .systemGreen
            break
        case .cancelled_by_vendor:
            cell.progressBar.stripesColor = .systemRed
            break
        case nil:
            cell.progressBar.stripesColor = .systemOrange
        }
        if AppLanguage.isArabic() {
            cell.progressBar.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else{
            cell.progressBar.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        cell.delegate = self // Set delegate
        
        return cell
    }
    
    /// Converts a date string from a specific input format to a `Date` object.
    func parseDate(from dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
        return formatter.date(from: dateString)
    }

    /// Formats a `Date` object into a string with a specific output format.
    func formatDate(_ date: Date, toFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}

