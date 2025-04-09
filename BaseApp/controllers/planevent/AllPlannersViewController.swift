//
//  AllPlannersViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/09/2024.
//

import UIKit
import SnapKit
import Combine

class AllPlannersViewController: UIViewController {
    
    private let viewModel:PlanEventViewModel = PlanEventViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var planners: Planners = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    private var fullListPlanners: Planners = []
    private let service:Service
    init(service: Service = .none) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "FriendsShimmerView")
        return view
    }()
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
    
    private let titleView:UIView = {
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
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        lbl.text = "Luxury event planners".localized
        return lbl
    }()
    
    private let searchView:CardView = {
        let card = CardView()
        card.backgroundColor = .white
        card.cornerRadius = 28.constraintMultiplierTargetValue.relativeToIphone8Height()
        card.shadowOffsetHeight = 0
        card.shadowOffsetWidth = 0
        card.shadowColor = .clear
        card.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        card.layer.borderWidth = 1
        return card
    }()
    
    
    lazy private var searchTF:UITextField = {
        let lbl = UITextField()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.placeholder = "Search for planners".localized
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.delegate = self
        return lbl
    }()
    
    
    private let searchIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        return icon
    }()
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(PlannerCell.self, forCellReuseIdentifier: "PlannerCell")
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        let ba = UIImage(named: "back_black")
        backBtn.setImage(AppLanguage.isArabic() ? ba?.tap_mirrored : ba, for: .normal)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView , tableView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        [titleView , searchView].forEach { view in
            self.headerView.addSubview(view)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-4)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        [backBtn , titleLbl].forEach { view in
            self.titleView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.constraintMultiplierTargetValue.relativeToIphone8Width())
            make.top.equalTo(self.titleLbl.snp.bottom).offset(19.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(56.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        [searchTF , searchIcon ].forEach { view in
            self.searchView.addSubview(view)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchTF.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.searchIcon.snp.leading)
            make.top.bottom.equalToSuperview()
        }
        
        backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$planners.receive(on: DispatchQueue.main).sink { planners in
            if self.viewModel.loading {return}
            guard let planners = planners else {
                //show empty state
                return
            }
            self.planners = planners
            self.fullListPlanners = planners
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        
        viewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModel.loading {return}
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        viewModel.loadPlanners()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension AllPlannersViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell") as! PlannerCell
        cell.planner = planners[safe:indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let planner = planners[safe:indexPath.row] {
            navigationController?.pushViewController(PlannerProfileViewController(planner:planner, service: self.service), animated: true)
        }
    }
}

extension AllPlannersViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string){
            if text.isEmpty {
                self.planners = fullListPlanners
            }else{
                planners = self.fullListPlanners.filter({ planner in
                    planner.name?.lowercased().contains(text.lowercased()) == true || planner.nameAr?.lowercased().contains(text.lowercased()) == true
                })
            }
        }
        return true
    }
    
}
