//
//  DineOutTypesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/11/2024.
//

import Foundation
import UIKit
import SnapKit


class DineOutTypesViewController: BaseViewController {
    
    private let viewModel: PopUpsViewModel  = PopUpsViewModel()
    private var date:Date? = nil
    private var category:PopUPSCategory? = nil
    private var popupLocationDate: PopupLocationDate = PopupLocationDate()
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    lazy private var titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Pop-ups".localized
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    private let shimmerView: ShimmerView = {
        let view = ShimmerView(nibName: "PopUpsCategories")
        return view
    }()
    
    lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(DinoutTypeCell.self, forCellReuseIdentifier: DinoutTypeCell.identifier)
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    
    private var categories:[PopUPSCategory] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    override func setup() {
        backBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        backBtn.tintColor = .black
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerView.addSubview(headerView)
        self.containerView.addSubview(tableView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        [backBtn , titleLbl].forEach { view in
            self.headerView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        viewModel.getReservationCategories()
    }
    
    
    override func observers() {
        viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.shimmerView.showShimmer(vc: self)
            }else{
                self.shimmerView.hideShimmer(vc: self)
            }
        }.store(in: &cancellables)
        
        viewModel.$loadingSubCategories.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        
        viewModel.$categories.dropFirst().receive(on: DispatchQueue.main).sink { res in
            self.categories = res?.data ?? []
        }.store(in: &cancellables)
        
        
        viewModel.$governorates.dropFirst().receive(on: DispatchQueue.main).sink { res in
            let vc = PlacesViewController(category: self.category, governates: res ?? [], popupLocationDate: self.popupLocationDate)
            self.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        
    }
    
    override func actions() {
        self.backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


extension DineOutTypesViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DinoutTypeCell.identifier) as! DinoutTypeCell
        let category = categories[safe: indexPath.row]
        cell.category = category
        cell.titleLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        cell.descriptionLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        cell.tap = { [weak self] in
            guard let self else { return }
            self.category = category
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                CalendarViewController.show(on: self, cartType: .popups, selectedDate: self.date, startDate: tomorrow, delegate: self)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
    }

}
extension DineOutTypesViewController: DaySelectionDelegate, OccasionTimeSelectionDelegate {
    func dayDidSelected(day: Day?) {
        self.date = day?.date
        self.popupLocationDate.date = DateFormatter.formateDate(date: day?.date ?? Date(), formate: "yyyy-MM-dd")
        self.popupLocationDate.day = DateFormatter.formateDate(date: day?.date ?? Date(), formate: "MMM")
        
        let vc = DineOutReservationTimeViewController(date: self.popupLocationDate.date ?? "")
        vc.delegate = self
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
    
    func timeDidSelected(time: PreferredTime?) {
        self.popupLocationDate.time = time?.displaytext
        self.viewModel.getGovernorates()
    }
}
