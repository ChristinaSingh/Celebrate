//
//  SendGiftFriendsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class SendGiftFriendsViewController: BaseViewController {
    
    
    let date:Date
    var addressId:String
    var locationId:String
    var time:PreferredTime?
    private let viewModel:SendGiftViewModel
    private var friends: Friends = []
    init(date: Date, time:PreferredTime?) {
        self.date = date
        self.addressId = ""
        self.locationId = ""
        self.viewModel = SendGiftViewModel()
        self.friends = []
        self.time = time
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "GiftFriendsView")
        return view
    }()
    
    let headerView:HeaderView = {
        let view = HeaderView(title: "Gift a friend".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    
    
    lazy private var friendList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionVeiw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVeiw.register(GiftsFriendsCell.self, forCellWithReuseIdentifier: GiftsFriendsCell.identifier)
        collectionVeiw.register(NoFriendsFoundCell.self, forCellWithReuseIdentifier: NoFriendsFoundCell.identifier)
        collectionVeiw.register(GiftsFriendsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GiftsFriendsHeader.identifier)
        collectionVeiw.delegate = self
        collectionVeiw.dataSource = self
        collectionVeiw.backgroundColor = .clear
        collectionVeiw.showsVerticalScrollIndicator = false
        return collectionVeiw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.back(vc: self)
        
        [headerView, friendList].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(98)
        }
        
        
        friendList.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        self.viewModel.getFreindsList()
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
        
        
        self.viewModel.$friends.dropFirst().receive(on: DispatchQueue.main).sink { friends in
            self.friends = friends ?? []
            self.friendList.reloadData()
        }.store(in: &cancellables)
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


extension SendGiftFriendsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count > 0 ? friends.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if friends.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoFriendsFoundCell.identifier, for: indexPath) as! NoFriendsFoundCell
            cell.inviteBtn.tap {
                let vc = FriendsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftsFriendsCell.identifier, for: indexPath) as! GiftsFriendsCell
            cell.friend = self.friends[safe: indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if friends.isEmpty {
            return CGSize(width: collectionView.frame.width, height: 400)
        }else{
            let width = (collectionView.frame.width - 16) / 2
            return CGSize(width: width, height: width)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GiftsFriendsHeader.identifier, for: indexPath) as! GiftsFriendsHeader
        header.sendGiftBtn.tap {
            let vc = SelectAddressViewController(cartType: .gift)
            vc.callback = { address in
                guard let address = address else {return}
                self.addressId = address.id ?? ""
                self.locationId = address.location?.locationID ?? ""
                self.navigationController?.pushViewController(GiftsSubCategoriesViewController(date: self.date, addressId: self.addressId, locationId: self.locationId, time: self.time, friend: nil), animated: true)
            }
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 176)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let friend = self.friends[safe: indexPath.row] else { return }
        guard let addressId = friend.addressId, let locationId = friend.locationId else { return }
        self.addressId = addressId
        self.locationId = locationId
        let vc = GiftsSubCategoriesViewController(date: self.date, addressId: self.addressId, locationId: self.locationId, time: self.time, friend: friend)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
