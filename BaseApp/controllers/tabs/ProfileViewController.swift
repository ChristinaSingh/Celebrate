//
//  ProfileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private let containerView:UIView = {
        let view = UIView()
        view.alpha = 0.05
        view.layer.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1).cgColor
        return view
    }()
    
    
    private let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView.register(ProfileDetailsCell.self, forCellWithReuseIdentifier: "ProfileDetailsCell")
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        return collectionView
    }()
    
    
    private var settings:[SettingModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.snp.top).offset(-self.view.safeAreaInsets.top)
        }
        
        setupProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(setupProfile), name: Notification.Name(rawValue: "LanguageChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupProfile), name: Notification.Name("user.updated"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc private func setupProfile() {
        settings = [
            SettingModel(setting: .wishlist , title: "Wishlist".localized , icon: UIImage(named: "settings_heart")),
            SettingModel(setting: .friends , title: "Friends".localized , icon: UIImage(named: "friends") , notify: true),
            SettingModel(setting: .orders , title: "Orders".localized , icon: UIImage(named: "orders")),
            SettingModel(setting: .occassions , title: "My Celebration".localized , icon: UIImage(named: "celebrations")),
            SettingModel(setting: .addresses , title: "Saved address".localized , icon: UIImage(named: "addresses")),
            SettingModel(setting: .contact , title: "Contact us".localized , icon: UIImage(named: "support")),
        ]
        collectionView.reloadData()
    }
    
}
extension ProfileViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.setting = settings.get(at: indexPath.row)
        cell.titleLbl.font =  AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 48) / 2, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as! ProfileHeaderView
        header.user = User.load()?.details
        header.profileTitleLbl.text = "Edit Profile".localized
        header.profileTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        header.favoritesTitleLbl.text = "My Gifts".localized
        header.favoritesTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        header.celebrationsTitleLbl.text = "Celebrations".localized
        header.celebrationsTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        header.callback = { [weak self] action in
            switch action {
            case .settings:
                let vc = SettingsViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
                break
            case .notifications://needs new page with api
                let vc = NotificationVC()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
                break

            case .editProfile:
                let vc = EditProfileDetailsViewController()
                vc.isModalInPresentation = true
                self?.present(vc, animated: true)
                break
            case .favorite:
                let vc = FavoritesViewController()
                vc.isModalInPresentation = true
                self?.present(vc, animated: true)
            case .celebrations:
                let vc = CelebrationsViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 432)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let setting = settings.get(at: indexPath.row) else {
            return
        }
        if let vc: UIViewController = switch setting.setting {
        case .wishlist:
            MyWishListViewController()
        case .friends:
            FriendsViewController()
        case .orders:
            OrdersViewController()
        case .occassions:
            MyCelebrationVC()
        case .addresses:
            AddressesViewController()
        case .contact:
            ContactViewController()
        default:
            nil
        }{
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   
}
