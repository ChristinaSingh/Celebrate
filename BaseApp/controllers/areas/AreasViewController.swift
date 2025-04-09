//
//  AreasViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/08/2024.
//

import Foundation
import SnapKit
import UIKit

protocol AreaSelectionDelegate {
    func areaDidSelected(area:Area?)
}

class AreasViewController: UIViewController {
    
    private let delegate:AreaSelectionDelegate?
    private let timeDelegate: DaySelectionDelegate?
    private var areas:Areas
    private let cartType:CartType?
    private var filteredAreas:Areas{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    init(delegate: AreaSelectionDelegate? = nil, timeDelegate: DaySelectionDelegate? = nil, cartType:CartType? = nil) {
        self.delegate = delegate
        self.areas = []
        self.filteredAreas = []
        self.timeDelegate = timeDelegate
        self.cartType = cartType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Locations")
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Event location".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    private let searchView:UIView = {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return card
    }()
    
    
    private let searchTF:UITextField = {
        let lbl = UITextField()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    private let searchIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        return icon
    }()
    
    
    private lazy var  tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(AreaCell.self, forCellReuseIdentifier: "AreaCell")
        tableView.register(AreaHeader.self, forHeaderFooterViewReuseIdentifier: "AreaHeader")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.headerView.cancelBtn.tap {
            if OcassionLocation.shared.getArea() == nil && self.cartType == .normal{
                ToastBanner.shared.show(message: "Please select an area.".localized, style: .info, position: .Top)
                return
            }
            self.dismiss(animated: true)
        }
        
        [headerView, tableView].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(58)
        }
        
        [searchTF , searchIcon].forEach { view in
            self.searchView.addSubview(view)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.searchIcon.snp.leading)
        }
        
        searchTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        headerView.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        
        headerView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        tableView.tableHeaderView = headerView
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        loadAreas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func loadAreas() {
        showShimmer()
        OcassionLocation.shared.loadAreas { areas in
            self.hideShimmer()
            if let areas{
                self.areas = areas
                self.filteredAreas = areas
            }
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        filteredAreas.removeAll()
        let searchText = textField.text ?? ""
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            filteredAreas = areas
        }else{
            for (_ , city) in areas.enumerated(){
                var mCity = city
                mCity.locations = city.locations?.filter{(location:Area) -> Bool in
                    return location.name?.lowercased().contains(searchText.lowercased()) == true || location.arName?.lowercased().contains(searchText.lowercased()) == true
                }
                if mCity.locations?.count ?? 0 > 0 {
                    filteredAreas.append(mCity)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    class func show(on viewController: UIViewController, delegate:AreaSelectionDelegate? = nil) {
        let vc = AreasViewController(delegate: delegate)
        vc.isModalInPresentation = true
        viewController.present(vc, animated: true)
    }
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.shimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    private func hideShimmer(){
        shimmerView.removeFromSuperview()
    }
}
extension AreasViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredAreas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAreas[safe: section]?.isExpanded == true ? filteredAreas[safe: section]?.locations?.count ?? 0 : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell") as! AreaCell
        cell.area = filteredAreas[safe: indexPath.section]?.locations?[safe: indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AreaHeader") as! AreaHeader
        header.area = filteredAreas[safe: section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let timeDelegate {
            self.delegate?.areaDidSelected(area: self.filteredAreas[safe: indexPath.section]?.locations?[safe: indexPath.row])
            self.navigationController?.pushViewController(DeliveryTimeViewController(delegate: timeDelegate), animated: true)
        }else{
            self.dismiss(animated: true) {
                self.delegate?.areaDidSelected(area: self.filteredAreas[safe: indexPath.section]?.locations?[safe: indexPath.row])
            }
        }
    }
}

        
