//
//  SettingsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit
import Combine

class SettingsViewController: UIViewController {
    
    private var settings:[String:[SettingModel]] = [:]
    
    
    private let viewModel:AddressesViewModel
    private let profileViewModel:ProfileViewModel
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.viewModel = AddressesViewModel()
        self.profileViewModel = ProfileViewModel()
        self.cancellables = Set<AnyCancellable>()
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

    
    let headerView:HeaderView = {
        let view = HeaderView(title: "Settings".localized)
        view.backgroundColor = .white
        view.withLogoutBtn = true
        return view
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Settings")
        return view
    }()

    
    lazy private var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .singleLine
        table.separatorColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        table.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        table.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: "SettingsHeader")
        table.register(SettingsFooter.self, forHeaderFooterViewReuseIdentifier: "SettingsFooter")
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        table.contentInsetAdjustmentBehavior = .never
        table.layoutMargins = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private var keys:[String] = []
    
    private let allowFriendsToPlanEventsLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow friends to plan events".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = .black
        return label
    }()
    
    private let allowFriendsToPlanEventsSwitch: UISwitch = {
        let toggle = UISwitch()
        // Set default value as needed or load from user preferences.
        toggle.isOn = false
        return toggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSettings()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        headerView.back(vc: self)
        self.headerView.logoutBtn.tap {
            self.headerView.enableLogout(vc: self)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, tableView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        viewModel.$shareLoading.receive(on: DispatchQueue.main).sink { isLoading in
            self.settings["Preferences".localized]?[safe:1]?.isLoading = isLoading
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .none)
        }.store(in: &cancellables)
        
        
        profileViewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.settings["Preferences".localized]?[safe:0]?.isLoading = isLoading
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
            }
        }.store(in: &cancellables)
        
        profileViewModel.$updatedUser.receive(on: DispatchQueue.main).sink { user in
            guard let user = user, let details = user.details else {return}
            if let savedUser = User.load() {
                savedUser.details?.ispublic = details.ispublic
                savedUser.save()
            }
            self.settings["Preferences".localized]?[safe:0]?.isOn = details.ispublic != "0"
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
            }
        }.store(in: &cancellables)
        
        profileViewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        
        viewModel.$changeLoading.receive(on: DispatchQueue.main).sink { isLoading in
            self.settings["Preferences".localized]?[safe:1]?.isChangeLoading = isLoading
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .none)
            }
        }.store(in: &cancellables)
        
        
        viewModel.$sharedAddress.receive(on: DispatchQueue.main).sink { address in
            guard let address = address else{return}
            if let _ = self.settings["Preferences".localized]?[safe:1]?.address {
                self.settings["Preferences".localized]?[safe:1]?.address = nil
                self.settings["Preferences".localized]?[safe:1]?.isOn = false
            }else{
                self.settings["Preferences".localized]?[safe:1]?.address = address
                self.settings["Preferences".localized]?[safe:1]?.isOn = true
            }
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
            }
        }.store(in: &cancellables)
        
        
        viewModel.$changedAddress.receive(on: DispatchQueue.main).sink { address in
            guard let address = address else{return}
            self.settings["Preferences".localized]?[safe:1]?.address = address
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
            }
        }.store(in: &cancellables)
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$addresses.receive(on: DispatchQueue.main).sink { addresses in
            if self.viewModel.loading {return}
            self.tableView.isHidden = false
            if let addresses = addresses?.addresses , !addresses.isEmpty {
                if let address = addresses.first(where: { address in
                    address.isshared == "1"
                }){
                    self.settings["Preferences".localized]?[safe:1]?.isOn = true
                    self.settings["Preferences".localized]?[safe:1]?.address = address
                }
                UIView.performWithoutAnimation {
                    self.tableView.reloadRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModel.loading {return}
            self.tableView.isHidden = true
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        viewModel.getAddresses()
    }
    
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        self.tableView.isHidden = true
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
        self.tableView.isHidden = false
        shimmerView.removeFromSuperview()
    }
    
    
    private func shareAddress(isOn:Bool, address:Address, isChange:Bool){
        self.viewModel.shareAddress(address: address, status: isOn ? "1" : "0", isChange: isChange)
    }
    
    
    private func setupSettings(){
        self.keys = ["Personal".localized, "Communication".localized, "App".localized] // removed "Preferences"
        self.settings = [
            "Personal".localized :[
                // If you had an .editProfile setting, keep it so that the user can access the Edit Profile screen.
                SettingModel(setting: .editProfile, title: "Edit profile details".localized, icon: UIImage(named: "edit_profile")),
                SettingModel(setting: .changePassword, title: "Change password".localized, icon: UIImage(named: "change_password")),
            ],
            "Communication".localized :[
                SettingModel(setting: .changeMobileNumber, title: "Change mobile number".localized, icon: UIImage(named: "phone")),
                SettingModel(setting: .editEmailAddress, title: "Add email address".localized, icon: UIImage(named: "email_settings"), notify: User.load()?.details?.email == nil),
            ],
            "App".localized :[
                SettingModel(setting: .language, title: "Language".localized, icon: UIImage(named: "language"), isButton: true),
                // Other app settings...
            ]
        ]
    }

    
//    private func setupSettings(){
//        self.keys = ["Personal".localized, "Communication".localized, "Preferences".localized, "App".localized]
//        self.settings = [
//            "Personal".localized :[
////                SettingModel(setting: .editProfile , title: "Edit profile details".localized , icon: UIImage(named: "edit_profile"), notify: User.load()?.details?.username == nil || User.load()?.details?.fullName == nil || User.load()?.details?.birthday == nil),
////                SettingModel(setting: .favorites , title: "Add favorites".localized , icon: UIImage(named: "favorites"), notify: false),
//                SettingModel(setting: .changePassword , title: "Change password".localized , icon: UIImage(named: "change_password")),
//            ],
//            "Communication".localized :[
//                SettingModel(setting: .changeMobileNumber , title: "Change mobile number".localized , icon: UIImage(named: "phone")),
//                SettingModel(setting: .editEmailAddress , title: "Add email address".localized , icon: UIImage(named: "email_settings"), notify: User.load()?.details?.email == nil),
//            ],
//            "Preferences".localized :[
//                SettingModel(setting: .makeProfilePublic , title: "Make profile public".localized , icon: UIImage(named: "public_account"), toggle: true, isOn: User.load()?.details?.ispublic != "0"),
//                SettingModel(setting: .allowFriendsToPlanEvents , title: "Allow friends to plan events".localized , icon: UIImage(named: "friends_plan"), toggle: true, isOn: false),
//            ],
//            "App".localized :[
//                SettingModel(setting: .language , title: "Language".localized , icon: UIImage(named: "language"), isButton: true),
//               // SettingModel(setting: .darkMode , title: "Dark mode".localized , icon: UIImage(named: "dark_mode"), toggle: true, isOn: false),
//            ]
//        ]
//    }

}
extension SettingsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[keys.get(at: section) ?? ""]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.setting = settings[keys.get(at: indexPath.section) ?? ""]?.get(at: indexPath.row)
        cell.isLast = settings[keys.get(at: indexPath.section) ?? ""]?.isLastIndex(indexPath.row) == true
        cell.button.setTitle(AppLanguage.isArabic() ? "English" : "عربي", for: .normal)
        cell.changeBtn.setTitle("Change".localized.uppercased(), for: .normal)
        cell.changeBtn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        cell.button.titleLabel?.font = AppFont.shared.font(family: .DINP, fontWeight: .bold, size: 16)
        cell.titleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        cell.subTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        cell.button.tap {
            self.switchLanguage()
        }
        cell.changeBtn.tap {
            let vc = SelectAddressViewController()
            vc.callback = { address in
                guard let address = address else{return}
                self.shareAddress(isOn: true, address: address, isChange: true)
            }
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
        cell.callback = { address , isOn in
            if indexPath.row == 0 {
                if let user = User.load(), let details = user.details {
                    self.profileViewModel.updateProfile(name: details.fullName, email: details.email, mobile: details.mobileNumber, birthday: details.birthday, username: details.username, ispublic: isOn ? "1" : "0")
                }
                
            }else{
                if isOn {
                    let vc = SelectAddressViewController()
                    vc.callback = { address in
                        guard let address = address else{return}
                        self.shareAddress(isOn: isOn, address: address, isChange: false)
                    }
                    vc.cancelCallback = {
                        cell.toggle.isOn = false
                    }
                    vc.isModalInPresentation = true
                    self.present(vc, animated: true)
                }else{
                    guard let address = address else{return}
                    self.shareAddress(isOn: false, address: address, isChange: false)
                }
            }
        }
        cell.address = settings[keys.get(at: indexPath.section) ?? ""]?.get(at: indexPath.row)?.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeader") as? SettingsHeader
        header?.titleLbl.text = keys.get(at: section)
        header?.titleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.keys.isLastIndex(section) {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsFooter") as? SettingsFooter
            footer?.appVersionLbl.text = "\("App version".localized) \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            footer?.deleteBtn.setTitle("Delete my account permanently".localized, for: .normal)
            footer?.deleteBtn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
            footer?.deleteBtn.tap {
                ConfirmationAlert.show(on: self, title: "Delete Account".localized, message: "Are you sure you want to delete your account? This action cannot be undone and will permanently remove all your data.".localized, icon:UIImage(named: "error"), positiveButtonTitle: "Delete Account".localized) {
                    footer?.deleteBtn.isHidden = true
                    footer?.activityIndiactor.isHidden = false
                    footer?.activityIndiactor.startAnimating()
                    AuthControllerAPI.deleteAccount { data, error in
                        DispatchQueue.main.async {
                            footer?.activityIndiactor.stopAnimating()
                            if let error = error {
                                footer?.deleteBtn.isHidden = false
                                footer?.activityIndiactor.isHidden = true
                                MainHelper.handleApiError(error)
                            }else if let res = data {
                                if res.message?.lowercased() == "Success".lowercased(){
                                    User.remove()
                                    let vc = IntroViewController()
                                    let nav = UINavigationController(rootViewController: vc)
                                    nav.setNavigationBarHidden(true, animated: true)
                                    if let sceneDelegate = UIApplication.shared.connectedScenes
                                        .first?.delegate as? SceneDelegate {
                                        sceneDelegate.changeRootViewController(nav)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return footer
        }else{
            return nil
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc: UIViewController = switch settings[keys.get(at: indexPath.section) ?? ""]?.get(at: indexPath.row)?.setting {
        case .editProfile:
            EditProfileDetailsViewController()
        case .favorites:
            FavoritesViewController()
        case .changePassword:
            ChangePasswordViewController()
        case .changeMobileNumber:
            ChangeMobileNumberViewController()
        case .editEmailAddress:
            AddEmailAddressViewController()
        default:
            nil
        }{
            vc.isModalInPresentation = true
            vc.providesPresentationContextTransitionStyle = true
            if vc is ChangeMobileNumberViewController {
                (vc as! ChangeMobileNumberViewController).callback = { phoneNum in
                    self.navigationController?.pushViewController(VerifyMobileViewController(phoneNum: phoneNum, service: .UpdatePhone), animated: true)
                }
            }
            self.present(vc, animated: true)
        }
        
    }
    
    private func switchLanguage() {
        changeLanguage()
        self.headerView.title = "Settings".localized
        self.headerView.backBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        self.headerView.backBtn.tintColor = .black
        let logout = UIImage(named: "logout")
        self.headerView.logoutBtn.setImage(AppLanguage.isArabic() ? logout?.tap_mirrored : logout, for: .normal)
        self.headerView.titleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        self.setupSettings()
        tableView.reloadData()
    }
    
}
