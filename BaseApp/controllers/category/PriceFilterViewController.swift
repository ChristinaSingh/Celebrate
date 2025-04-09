//
//  PriceFilterViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/06/2024.
//

import UIKit
import SnapKit

class PriceFilterViewController: UIViewController {
    
    private let delegate:FilterSelected
    private let price:PriceFilter?
    init(delegate: FilterSelected, prices:PriceFilter?) {
        self.delegate = delegate
        self.price = prices
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Filter by price".localized.uppercased()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    lazy private var tableView:UITableView = {
        let table = UITableView()
        table.register(FilterPriceCell.self, forCellReuseIdentifier: "FilterPriceCell")
        table.layer.cornerRadius = 8
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        return table
    }()
    
    
    private var prices:[PriceFilter] = [PriceFilter(title: "Any price".localized, type: .AnyPrice), PriceFilter(title: "Under KD 100".localized, type: .Under100), PriceFilter(title: "KD 100 - 200".localized, type: .From100To200), PriceFilter(title: "Over KD 200".localized, type: .Over200)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLbl, tableView].forEach { view in
            self.view.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.leading.equalToSuperview().offset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
        if let index = self.prices.firstIndex(where: { price in
            self.price?.type == price.type
        }){
            self.prices[index].isSelected = true
        }
    }
    
    
    func reset(){
        for (index, _) in prices.enumerated() {
            self.prices[index].isSelected = false
        }
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
        }
    }
    
    
    func getSelections() -> PriceFilter?{
        return self.prices.filter { price in
            price.isSelected
        }.first
    }

}
extension PriceFilterViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPriceCell", for: indexPath) as! FilterPriceCell
        cell.price = prices.get(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for (index, _) in self.prices.enumerated() {
            self.prices[index].isSelected = false
        }
        self.prices[safe: indexPath.row]?.isSelected = true
        tableView.reloadData()
        self.delegate.isSelected()
    }
}
