//
//  SelectFavoriteItemsController.swift
//  BaseApp
//
//  Created by Ihab yasser on 20/01/2025.
//

import Foundation
import UIKit
import SnapKit
import Combine

class SelectFavoriteItemsController: UIViewController {
    
    
    private let viewModel:ProfileViewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var likes: [Product] = []
    private let subCatId:String
    init(subCatId: String) {
        self.subCatId = subCatId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Favorites".localized)
        view.backgroundColor = .white
        return view
    }()
    
    var emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "empty_wish_list"), message: "No items to show at the moment.".localized, imgSize: CGSize(width: 120, height: 120))
        view.icon = UIImage(named: "empty_wish_list")
        view.message = "No items to show at the moment.".localized
        return view
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "MyFavoritesShimmer")
        return view
    }()
    
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FriendLikeCell.self, forCellWithReuseIdentifier: "FriendLikeCell")
        
        return collectionView
    }()
    
    
    private let saveCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    private lazy var saveBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Save".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.button.setTitleColor(UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5), for: .normal)
        btn.button.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.button.layer.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        btn.button.isUserInteractionEnabled = false
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView, collectionView, saveCardView, emptyState].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        saveCardView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        saveCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(101)
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.saveCardView.snp.top).offset(10)
        }
        
        emptyState.isHidden = true
        emptyState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.5)
            make.height.equalTo(200)
            
        }
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$updateloading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        viewModel.$favoritesUpdated.dropFirst().receive(on: DispatchQueue.main).sink { isUpdated in
            if isUpdated?.status?.int == 1 {
                self.dismiss(animated: true)
            }else{
                MainHelper.showToastMessage(message: isUpdated?.message ?? "", style: .error, position: .Top)
            }
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        viewModel.$likes.dropFirst().receive(on: DispatchQueue.main).sink { res in
            if self.viewModel.loading {return}
            self.likes = res ?? []
            if self.likes.isEmpty{
                self.collectionView.isHidden = true
                self.saveCardView.isHidden = true
                self.emptyState.isHidden = false
            }else{
                self.collectionView.isHidden = false
                self.saveCardView.isHidden = false
                self.emptyState.isHidden = true
            }
            self.collectionView.reloadData()
            self.saveBtn.enableDisableSaveButton(isEnable: self.likes.filter({ $0.isGiftFav == 1 }).isEmpty == false)
        }.store(in: &cancellables)
        
        
        saveBtn.tap = {
            self.viewModel.updateFavorites(ids: self.likes.filter({ $0.isGiftFav == 1 }).map({ $0.id ?? ""}).joined(separator: ","), subCatIds: self.subCatId)
        }
        
        viewModel.getLikes(subCatId: self.subCatId)
        
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
extension SelectFavoriteItemsController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.likes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendLikeCell", for: indexPath) as! FriendLikeCell
        cell.like = self.likes.get(at: indexPath.row)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3 * 16) / 3
        return CGSize(width: width, height: width + 32)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isFav = self.likes[safe: indexPath.row]?.isGiftFav
        self.likes[safe: indexPath.row]?.isGiftFav =  isFav == 1 ? 0 : 1
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
        saveBtn.enableDisableSaveButton(isEnable: self.likes.filter({ $0.isGiftFav == 1 }).isEmpty == false)
    }

}
