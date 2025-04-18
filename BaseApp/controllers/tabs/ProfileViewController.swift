//
//  ProfileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit
import Contacts


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
    
    //x-api-key
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
        

        if  UserDefaults.standard.value(forKey: "ContactSync") == nil {
            ContactUploader().fetchAndUploadContacts()
        }

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

struct Contact: Codable {
    let name: String
    let phone: String
}

struct ContactSyncRequest: Codable {
    let contacts: [Contact]
}

struct APIResponse: Codable {
    let status: String
    let message: String
}

class ContactUploader {

    func fetchAndUploadContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                var contacts: [Contact] = []

                do {
                    try store.enumerateContacts(with: request) { contact, _ in
                        for phoneNumber in contact.phoneNumbers {
                            let name = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                            let number = phoneNumber.value.stringValue.filter("0123456789+".contains)
                            contacts.append(Contact(name: name, phone: number))
                        }
                    }
                    self.uploadContacts(contacts)
                } catch {
                    print("Failed to fetch contacts:", error)
                }
            } else {
                print("Permission denied or error:", error ?? "")
            }
        }
    }

    private func uploadContacts(_ contacts: [Contact]) {
        guard let url = URL(string: "https://celebrate.inchrist.co.in/api/friends/synk") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = User.load()?.token {
            request.setValue(token, forHTTPHeaderField: "x-api-key") // ✅ Custom header
        }

        let body = ContactSyncRequest(contacts: contacts)
        
        print("contactscontacts \(contacts)")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Failed to encode contacts:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Upload response:", response)
                    DispatchQueue.main.async {
                        UserDefaults.standard.setValue("Yes", forKey: "ContactSync")
                        ToastBanner.shared.show(message: "Contact Uploaded successfully", style: .success, position: .Bottom)
                    }
                } catch {
                    print("Failed to parse response:", error)
                }
            } else {
                print("Request failed:", error ?? "")
            }
        }.resume()
    }

}
