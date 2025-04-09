//
//  DineOutReservationTimeViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 08/12/2024.
//

import Foundation
import UIKit
import Combine
import SnapKit

class DineOutReservationTimeViewController: OccasionTimeViewController {
    
    private let viewModel:PopUpsViewModel = PopUpsViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var times:PreferredTimes = []{
        didSet {
            self.tableView.reloadData()
        }
    }
    private let date:String
    init(date:String) {
        self.date = date
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        viewModel.$times.receive(on: DispatchQueue.main).sink { times in
            self.times = times ?? []
        }.store(in: &cancellables)
    }

    
    override func loadTimes() {
        viewModel.getDeliveryTimes()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrateTimeSlotCell") as! CelebrateTimeSlotCell
        cell.time = times[safe:indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.timeDidSelected(time: self.times[safe:indexPath.row])
        }
    }
}
