//
//  PlanEventOccasionViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//

import Foundation
import UIKit

class PlanEventOccasionViewController: OccassionViewController {
    
    private var body:PlanEventBody
    private let service: Service
    
    init(body: PlanEventBody, service: Service) {
        self.body = body
        self.service = service
        super.init(service: service)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var eventOccassions: PlanEventOccasions?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    internal let planEventViewModel: PlanEventViewModel = PlanEventViewModel()
    
    
    override func observers() {
        super.observers()
        
        planEventViewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading{
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        planEventViewModel.$occasions.receive(on: DispatchQueue.main).sink { occasions in
            self.eventOccassions = occasions
        }.store(in: &cancellables)
    }
    
    override func loadData() {
        planEventViewModel.getOccasions(plannerId: self.body.eventPlannerID ?? "")
    }
    
    override func actions() {
        self.proceedBtn.tap = {
            let occassions = self.eventOccassions?.filter({ occasion in
                occasion.isSelected
            }) ?? []
            self.body.occasions = occassions.filter({ $0.id?.isBlank == false }).map{ $0.id ?? "" }.joined(separator: ",")
            self.navigationController!.pushViewController(PlanEventDateViewController(service: self.service, body: self.body), animated: true)

        }
    }
    
}

extension PlanEventOccasionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventOccassions?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OccasionCell", for: indexPath) as! OccasionCell
        cell.eventOccasion = eventOccassions?[safe:indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.eventOccassions?.forEachIndexed({ index, _ in
            self.eventOccassions?[index].isSelected = false
        })
        if self.eventOccassions?.get(at: indexPath.row)?.isSelected == true {
            self.eventOccassions?[safe:indexPath.row]?.isSelected = false
        }else{
            self.eventOccassions?[safe:indexPath.row]?.isSelected = true
        }
        self.proceedBtn.enableDisableSaveButton(isEnable: self.eventOccassions?.filter({ occasion in
            occasion.isSelected
        }).count ?? 0 > 0)
    }
}
