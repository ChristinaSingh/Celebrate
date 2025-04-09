//
//  OffersViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/09/2024.
//

import UIKit

class OffersViewController: MyWishListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title = "Exclusive offers".localized
        emptyState.icon = UIImage(named: "empty_wish_list")
        emptyState.message = "Looks like you there is no offers at that time".localized
        viewModel.$offers.receive(on: DispatchQueue.main).sink { products in
            if self.viewModel.loading {return}
            if let products = products , products.products?.isEmpty == false{
                self.products = products
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
                self.emptyState.isHidden = true
            }else{
                self.collectionView.isHidden = true
                self.emptyState.isHidden = false
            }
        }.store(in: &cancellables)
    }

    
    override func loadData() {
        self.viewModel.offers(body: ProductsParameters(eventDate: OcassionDate.shared.getDate(), subcategoryID: "", pageindex:"1", pagesize:"10000", locationID: OcassionLocation.shared.getAreaId(), customerID: User.load()?.details?.id))
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ProductCell
        cell.favoriteBtn.isHidden = true
        cell.favoriteBtn.isUserInteractionEnabled = false
        return cell
    }
}
