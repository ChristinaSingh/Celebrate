//
//  SendGiftViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 08/12/2024.
//

import Foundation
import UIKit
import SnapKit

class SendGiftViewController: MyWishListViewController {
    
    let date:Date
    let addressId:String
    let subCategoryId:String
    var locationId:String
    let time:PreferredTime?
    let isFriendSubCategory:Bool
    let friendId:String?
    private let addressesViewModel = AddressesViewModel()
    init(date: Date, addressId:String, subCategoryId:String, locationId:String, time:PreferredTime?, isFriendSubCategory:Bool, friendId:String?) {
        self.date = date
        self.addressId = addressId
        self.subCategoryId = subCategoryId
        self.locationId = locationId
        self.time = time
        self.isFriendSubCategory = isFriendSubCategory
        self.friendId = friendId
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.title = "Send Gifts".localized
        emptyState.message = "No items to show at the moment.".localized
    }
    
    override func loadData(){
        if isFriendSubCategory {
            viewModel.getFriendLikes(friendId: subCategoryId)
        }else{
            viewModel.gifts(subcategories: subCategoryId)
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
        let vc = ProductDetailsViewController(product: self.selectedProduct,locationId: self.locationId ,cartType: .gift, giftAddressId: self.addressId, giftDate: DateFormatter.formateDate(date: self.date, formate: "yyyy-MM-dd"), cartTime: self.time?.displaytext ?? "", friendId: self.friendId)
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
}
