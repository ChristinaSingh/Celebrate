//
//  SetupItemsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/11/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class SetupItemsViewController: MyWishListViewController {
    
    private let popUpsViewModel:PopUpsViewModel = PopUpsViewModel()
    private let popupLocationDate: PopupLocationDate
    private let category:PopUPSCategory?
    init(category: PopUPSCategory?, popupLocationDate: PopupLocationDate) {
        self.popupLocationDate = popupLocationDate
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title = "Pop-ups".localized
        emptyState.icon = UIImage(named: "empty_wish_list")
        emptyState.message = "Looks like you there is no setup products available at that time".localized
        self.emptyState.isHidden = true
        popUpsViewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.emptyState.isHidden = true
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        popUpsViewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink{ error in
            if self.popUpsViewModel.loading {return}
            MainHelper.handleApiError(error)
            self.collectionView.isHidden = true
            self.emptyState.isHidden = false
        }.store(in: &cancellables)
        
        popUpsViewModel.$items.dropFirst().receive(on: DispatchQueue.main).sink { products in
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
        if self.category?.imageType?.lowercased() == "restaurants".lowercased(){
            self.popUpsViewModel.getRestrauntItems()
        }else{
            self.popUpsViewModel.getProducts()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ProductCell
        cell.favoriteBtn.isHidden = true
        cell.favoriteBtn.isUserInteractionEnabled = false
        return cell
    }
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = products?.products?.get(at: indexPath.row) else { return }
        self.selectedProduct = product
        let vc = ProductDetailsViewController(product: product, locationId: popupLocationDate.cityId, cartType: .popups, popupLocationID: popupLocationDate.cityId, popupLocationDate: popupLocationDate)
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
}

