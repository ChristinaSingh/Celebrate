//
//  BundleItemsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/12/2024.
//

import Foundation
import UIKit
import SnapKit

protocol BundleItemsOptionsCellDelegate: AnyObject {
    func didUpdateHeight()
}

class BundleItemsOptionsCell: UITableViewCell {

    
    static let identifier:String = "BundleItemsOptionsCell"
    private var types:[ProductOption] = []
    weak var delegate: BundleItemsOptionsCellDelegate?
    fileprivate var cellHeights: [Int: [Int: CGFloat]] = [:]
    var productDetails:ProductDetails?{
        didSet{
            self.fillTypes()
        }
    }
    
    lazy var  tableView:ContentFittingTableView = {
        let table = ContentFittingTableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 50
        table.estimatedRowHeight = 100
        table.isScrollEnabled = false
        table.isScrollEnabled = false
        table.rowHeight = UITableView.automaticDimension
        table.register(ProductDetailsBannerCell.self, forCellReuseIdentifier: "ProductDetailsBannerCell")
        table.register(ProductDetailsDeliveryTimeCell.self, forCellReuseIdentifier: "ProductDetailsDeliveryTimeCell")
        table.register(ProductDetailsTitleCell.self, forCellReuseIdentifier: "ProductDetailsTitleCell")
        table.register(ProductDetailsDescriptionCell.self, forCellReuseIdentifier: "ProductDetailsDescriptionCell")
        table.register(ProductDetailsCancellationCell.self, forCellReuseIdentifier: "ProductDetailsCancellationCell")
        table.register(ProductDetailsSSSQCell.self, forCellReuseIdentifier: "ProductDetailsSSSQCell")
        table.register(ProductDetailsSSMQCell.self, forCellReuseIdentifier: "ProductDetailsSSMQCell")
        table.register(ProductDetailsMSSQCell.self, forCellReuseIdentifier: "ProductDetailsMSSQCell")
        table.register(ProductDetailsMSMQCell.self, forCellReuseIdentifier: "ProductDetailsMSMQCell")
        table.register(ProductDetailsYESNOCell.self, forCellReuseIdentifier: "ProductDetailsYESNOCell")
        table.register(ProductDetailsINPUTCell.self, forCellReuseIdentifier: "ProductDetailsINPUTCell")
        table.register(ProductDetailsSectionHeader.self, forHeaderFooterViewReuseIdentifier: "ProductDetailsSectionHeader")
        return table
    }()
    
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fillTypes(){
        guard let productDetails = productDetails else {
            return
        }
        self.types.removeAll()
        
        if let options = productDetails.options {
            for option in options {
                self.types.append(ProductOption.type(type: option.type ?? ""))
            }
        }
        //self.types = self.types.sorted(by: { $0.rawValue < $1.rawValue })
        self.tableView.reloadData()
        self.notifyHeightChange()
    }
    
    private func notifyHeightChange() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.layoutIfNeeded()
            self?.delegate?.didUpdateHeight()
        }
    }
    
}
extension BundleItemsOptionsCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.get(at: section)?.numberOfRows(productDetails: self.productDetails, section: section - getTopSectionsCount()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.types.get(at: indexPath.section)?.cellForRow(productDetails: self.productDetails, timeSlots: nil, tableView: tableView, indexPath: indexPath, topSectionsCount: getTopSectionsCount(), delegate: self){
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.types.get(at: indexPath.section)?.height(timeSlots: nil) ?? 0
    }
    
    private func getTopSectionsCount() -> Int{
        return self.types.filter { type in
            type == .BANNER || type == .TITLE || type == .DESCRIPTION || type == .CANCELLATION || type == .DELIVERY
        }.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.types.get(at: indexPath.section)?.tableView(tableView, productDetails: &self.productDetails, didSelectRowAt: indexPath, section: indexPath.section - getTopSectionsCount())
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.types.get(at: section)?.tableView(tableView, productDetails: self.productDetails, viewForHeaderInSection: section, section: section - getTopSectionsCount()){ productDetails in
            self.productDetails = productDetails
            self.notifyHeightChange()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.types.get(at: section)?.tableView(tableView, productDetails: productDetails, heightForHeaderInSection: section - getTopSectionsCount()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.types.get(at: section)?.tableView(tableView, heightForFooterInSection: section) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dict = cellHeights[indexPath.section] {
            if dict.keys.contains(indexPath.row) {
                return dict[indexPath.row]!
            } else {
                cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
                return UITableView.automaticDimension
            }
        }
        
        cellHeights[indexPath.section] = [:]
        cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
        return cellHeights[indexPath.section]![indexPath.row]!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dict = cellHeights[indexPath.section], dict[indexPath.row] == UITableView.automaticDimension {
            cellHeights[indexPath.section]![indexPath.row] = cell.bounds.height
        }
    }
}
extension BundleItemsOptionsCell: ProductOptionDelegate {
    func timesType(timeType: TimeSlotType, section: Int) {
    }
    
    func quantityChanged(count: Int, section: Int, tvSection: Int, row: Int) {
        self.productDetails?.options?[safe: section]?.config?.res?[safe: row]?.qty = count
        self.reloadSection(section: tvSection)
    }
    
    func textChanged(text: String, section: Int, tvSection: Int, row: Int) {
        self.productDetails?.options?[safe: section]?.inputText = text
        self.reloadSection(section: tvSection)
    }
    
    func select(qty: Int, section: Int, tvSection: Int, item: Int) {
        self.productDetails?.options?[safe: section]?.config?.res?[safe: item]?.qty = qty
        self.reloadSection(section: tvSection)
    }
    
    private func reloadSection(section:Int){
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
}
