//
//  PayNowOrLaterViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 31/08/2024.
//

import Foundation
import UIKit
import SnapKit

enum PayNowOrLaterType{
    case PayNow
    case PayLater
}

struct PayNowOrLater {
    let img: UIImage?
    let title:String
    let subTitle:String
    let type:PayNowOrLaterType
}


class PayNowOrLaterViewController:UIViewController {
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Pay now or later".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private lazy var  tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 50
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        table.register(PayNowOrLaterCell.self, forCellReuseIdentifier: "PayNowOrLaterCell")
        return table
    }()
    
    let array:[PayNowOrLater] = [
        PayNowOrLater(img: .payNow, title: "Pay Now".localized, subTitle: "You’ll be paying for the items that do not require an approval right away and the rest once they are approved.".localized, type: .PayNow),
        PayNowOrLater(img: .payLater, title: "Pay upon approval".localized, subTitle: "You’ll be paying for all the items once the products that require approval has been provided.".localized, type: .PayLater)
    ]
    
    var callback:((PayNowOrLaterType?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView, tableView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
    }
    
}
extension PayNowOrLaterViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayNowOrLaterCell") as! PayNowOrLaterCell
        cell.payNowOrLater = self.array.get(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true) {
            self.callback?(self.array.get(at: indexPath.row)?.type)
        }
    }
    
    
}
