//
//  GiftsSubCategoriesViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit

class GiftsSubCategoriesViewController: BaseViewController {
    
    let date:Date
    let addressId:String
    let locationId:String
    let time:PreferredTime?
    let friend:Friend?
    private let viewModel:SendGiftViewModel
    private var subCategories:[PopUPSCategory]
    init(date: Date, addressId:String, locationId:String, time:PreferredTime?, friend:Friend?) {
        self.date = date
        self.addressId = addressId
        self.locationId = locationId
        self.viewModel = SendGiftViewModel()
        self.time = time
        self.friend = friend
        self.subCategories = []
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "GiftsSubCategories")
        return view
    }()
    
    private let headerImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: AppLanguage.isArabic() ? "gift_shop_header_ar" : "gift_shop_header")
        return img
    }()
    
    
    let backBtn:UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"))
        return btn
    }()
    
    
    lazy private var subCategoriesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionVeiw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVeiw.register(GiftSubCategoriesCell.self, forCellWithReuseIdentifier: GiftSubCategoriesCell.identifier)
        collectionVeiw.delegate = self
        collectionVeiw.dataSource = self
        collectionVeiw.backgroundColor = .clear
        collectionVeiw.showsVerticalScrollIndicator = false
        collectionVeiw.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return collectionVeiw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        [headerImg, backBtn, subCategoriesCollectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        self.headerImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(210)
        }
        
        self.backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(64)
        }
        
        subCategoriesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerImg.snp.bottom)
            make.bottom.equalToSuperview().inset(20)
        }
        self.viewModel.getSubCategories()
    }
    
    
    override func observers() {
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        
        self.viewModel.$subCategories.dropFirst().receive(on: DispatchQueue.main).sink { subCategories in
            self.subCategories = subCategories ?? []
            if let friend = self.friend {
                if self.subCategories.canInsert(at: 0){
                    self.subCategories.insert(PopUPSCategory(id: friend.friendCustid, name: "@\(friend.customer?.username ?? "")", arName: "@\(friend.customer?.username ?? "")", status: nil, productType: nil, mediaID: nil, displayorder: nil, parentID: nil, pendingOrderApproval: nil, avgprice: nil, allowBundle: nil, isReservation: nil, desc: nil, descAr: nil, imageType: nil, imageUrl: friend.customer?.avatar?.imageURL, isFriendObject: true), at: 0)
                }
            }
            self.subCategoriesCollectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func actions() {
        self.backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerImg.snp.bottom)
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

extension GiftsSubCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftSubCategoriesCell.identifier, for: indexPath) as! GiftSubCategoriesCell
        cell.subCategory = subCategories[safe: indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3 * 16) / 3
        return CGSize(width: width, height: width + 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = self.subCategories[safe: indexPath.row]?.id, let isFriendObjc = self.subCategories[safe: indexPath.row]?.isFriendObject else { return }
        let vc = SendGiftViewController(date: self.date, addressId: self.addressId, subCategoryId: id, locationId: self.locationId, time: self.time, isFriendSubCategory: isFriendObjc, friendId: self.friend?.friendCustid)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
