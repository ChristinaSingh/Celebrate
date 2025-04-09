//
//  OccasionTimeViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import UIKit
import SnapKit
import Combine


protocol OccasionTimeSelectionDelegate {
    func timeDidSelected(time: TimeSlot?)
    func timeDidSelected(time: PreferredTime?)
}

extension OccasionTimeSelectionDelegate{
    func timeDidSelected(time: TimeSlot?){}
    func timeDidSelected(time: PreferredTime?){}
}

class OccasionTimeViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:CelebrateViewModel
    var delegate:OccasionTimeSelectionDelegate?
    private var times:[TimeSlot]{
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init() {
        self.viewModel = CelebrateViewModel()
        self.times = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "OccasionTimes")
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Select Time".localized)
        view.backgroundColor = .white
        return view
    }()

    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CelebrateTimeSlotCell.self, forCellReuseIdentifier: "CelebrateTimeSlotCell")
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
        
        self.headerView.cancel(vc: self)
        
        [headerView, tableView].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(58)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$timeSlots.receive(on: DispatchQueue.main).sink { times in
            self.times = times?.data ?? []
        }.store(in: &cancellables)
        
        loadTimes()
    }
    
    
    func loadTimes(){
        viewModel.loadTimeSlots()
    }
    
    
    func showShimmer(){
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
    
    
    func hideShimmer(){
        shimmerView.removeFromSuperview()
    }
    
    class func show(on viewController: UIViewController, delegate:OccasionTimeSelectionDelegate? = nil) {
        let vc = OccasionTimeViewController()
        vc.isModalInPresentation = true
        vc.delegate = delegate
        viewController.present(vc, animated: true)
    }

}
extension OccasionTimeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrateTimeSlotCell") as! CelebrateTimeSlotCell
        cell.timeSlot = times[safe:indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.timeDidSelected(time: self.times[safe:indexPath.row])
        }
    }
    
    
}
