//
//  DeliveryTimeViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/01/2025.
//

import Foundation
import UIKit
import SnapKit


class DeliveryTimeViewController: PlannerTimeSlotsViewController {
    
    private let viewmodel: CartViewModel = CartViewModel()
    private let timeDelegate: DaySelectionDelegate?
    private let time:String?
    init(delegate: DaySelectionDelegate?, time:String? = nil) {
        self.timeDelegate = delegate
        self.time = time
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.titleLbl.text = "Delivery Time".localized
        self.headerView.cancelBtn.tap {
            if OcassionDate.shared.getTime() == nil {
                ToastBanner.shared.show(message: "Please select delivery time.".localized, style: .info, position: .Top)
                return
            }
            self.dismiss(animated: true)
        }
        viewmodel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        
        viewmodel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewmodel.$times.dropFirst().receive(on: DispatchQueue.main).sink { times in
            let time = self.time == nil ? OcassionDate.shared.getTime() : self.time
            if let time = time, let index = times?.firstIndex(where: { $0.displaytext == time }) {
                self.times = times ?? []
                self.times[safe: index]?.isSelected = true
                self.tableView.reloadData()
            }else{
                self.times = times ?? []
            }
            
        }.store(in: &cancellables)
        
        loadTimes()
    }
    
    override func loadTimes() {
        viewmodel.getTimes()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.timeDelegate?.timeDidSelected(time: self.times[safe:indexPath.row])
        }
    }
}
