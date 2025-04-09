//
//  PlannerProfileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/06/2024.
//

import UIKit
import SnapKit
import Combine

class PlannerProfileViewController: UIViewController {
    
    
    private let planner:Planner
    private let viewModel:PlanEventViewModel = PlanEventViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var profile:PlannerProfile? = nil
    private let service:Service
    private let body:PlanEventBody
    init(planner: Planner, service: Service = .none) {
        self.service = service
        self.planner = planner
        self.body = PlanEventBody(mobile: User.load()?.details?.mobileNumber ,customerID: User.load()?.details?.id, eventPlannerID: planner.id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "")
        view.backgroundColor = .white
        return view
    }()
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "PlannerDetails")
        return view
    }()
    
    lazy private var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.register(PlannerDetailsCell.self, forCellReuseIdentifier: "PlannerDetailsCell")
        table.register(PlannerGalleryCell.self, forCellReuseIdentifier: "PlannerGalleryCell")
        table.register(ProductDetailsSectionHeader.self, forHeaderFooterViewReuseIdentifier: "ProductDetailsSectionHeader")
        table.register(ProductDetailsDescriptionCell.self, forCellReuseIdentifier: "ProductDetailsDescriptionCell")
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 50
        table.estimatedRowHeight = 100
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let bookCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    private lazy var bookBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Book now".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    private var cells:[PlannerProfileCellType] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title = AppLanguage.isArabic() ? self.planner.nameAr  ?? "" : self.planner.name ?? ""
        self.view.backgroundColor = .white
        self.view.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, bookCardView, tableView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        headerView.back(vc: self)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        bookCardView.addSubview(bookBtn)
        bookBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        bookCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(101)
            make.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.bookCardView.snp.top)
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$bookLoading.receive(on: DispatchQueue.main).sink { isLoading in
            self.bookBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        viewModel.$bookPlanner.receive(on: DispatchQueue.main).sink { response in
            guard let response = response else {return}
            if response.message?.lowercased() == "Success".lowercased(){
                let vc = AuthWelcomeViewController(service: .BookedPlanner)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                MainHelper.showToastMessage(message: response.message ?? "", style: .error, position: .Bottom)
            }
        }.store(in: &cancellables)
        
        viewModel.$plannerProfile.receive(on: DispatchQueue.main).sink { profile in
            guard let profile = profile else {return}
            self.profile = profile
            self.cells.removeAll()
            self.cells.append(.planner)
            self.cells.append(.about)
            if profile.first?.gallery?.isEmpty == false{
                self.cells.append(.gallery)
            }
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        
        viewModel.plannerProfile(plannerId: self.planner.id)
        
        bookBtn.tap = {
            if self.service == .PlanEvent {
                let vc = PlanEventUserNameViewController(service: self.service, body: self.body)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = PlannerTimeSlotsViewController(planner: self.planner)
                vc.delegate = self
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
        }
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
extension PlannerProfileViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells.get(at: indexPath.section) {
        case .planner:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerDetailsCell") as! PlannerDetailsCell
            cell.profile = self.profile?.first
            return cell
        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsDescriptionCell", for: indexPath) as! ProductDetailsDescriptionCell
            cell.contentView.backgroundColor = .white
            cell.desc = AppLanguage.isArabic() ? self.profile?.first?.aboutusAr : self.profile?.first?.aboutus
            cell.titleLbl.snp.remakeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-16)
            }
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
            cell.contentView.clipsToBounds = true
            return cell
        case .gallery:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerGalleryCell", for: indexPath) as! PlannerGalleryCell
            cell.gallery = self.profile?.first?.gallery ?? []
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
            cell.contentView.clipsToBounds = true
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductDetailsSectionHeader") as? ProductDetailsSectionHeader
        switch cells.get(at: section) {
        case .about:
            header?.containerView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(1)
            }
            header?.title = "about".localized
            header?.isExpanded = true
            return header
        case .gallery:
            header?.containerView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(1)
            }
            header?.title = "Gallery".localized
            header?.isExpanded = true
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch cells.get(at: section) {
        case .about, .gallery:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells.get(at: indexPath.section) {
        case  .gallery:
            let gallery = self.profile?.first?.gallery ?? []
            let itemWidth = (tableView.frame.width - 48) / 2
            let height = gallery.count % 2 == 0 ? (itemWidth * CGFloat(gallery.count) / 2) : itemWidth * CGFloat(Int(CGFloat(gallery.count) / 2) + 1)
            return height + 32
        default:
            return UITableView.automaticDimension
        }
    }
    
}
extension PlannerProfileViewController:OccasionTimeSelectionDelegate {
    func timeDidSelected(time: PreferredTime?) {
        self.viewModel.bookPlanner(selecteddate: OcassionDate.shared.getDate() ?? "", eventplannerid: self.planner.id ?? "", preferredtime: time?.displaytext ?? "", mobile: User.load()?.details?.mobileNumber ?? "", name: User.load()?.details?.fullName ?? "", preferredtimeid: time?.preftimeid ?? "")
    }

}
