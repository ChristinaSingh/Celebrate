//
//  ChangePasswordViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit
import Combine

class ChangePasswordViewController: UIViewController {

    private var bottomViewBottomConstraint: Constraint?
    private var keyboardManager: KeyboardManager?
    private let viewModel:ProfileViewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Change password".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor =  UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let currentPasswordLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Current password".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()

    
    lazy private var currentPassword:C8TextField = {
        let password = C8TextField()
        password.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        password.delegate = nil
        password.isUserName = false
        password.isPassword = true
        password.tag = 100
        password.textColor = .black
        password.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        password.backgroundColor = .white
        password.layer.cornerRadius = 8
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return password
    }()
    
    
    private let newPasswordLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "New password".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()

    
    lazy private var newPassword:C8TextField = {
        let password = C8TextField()
        password.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        password.delegate = nil
        password.isUserName = false
        password.isPassword = true
        password.tag = 101
        password.textColor = .black
        password.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        password.backgroundColor = .white
        password.layer.cornerRadius = 8
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return password
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
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    
    private let hintLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Your password should be at-least 8 characters long and it should contain at-least 1 number.".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView , scrollView, saveCardView].forEach { view in
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
            bottomViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.saveCardView.snp.top).offset(10)
        }
        
        [currentPasswordLbl, currentPassword, newPasswordLbl, newPassword, hintLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        currentPasswordLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(18)
        }
        
        
        currentPassword.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.currentPasswordLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        newPasswordLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.currentPassword.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        
        newPassword.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.newPasswordLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        hintLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.newPassword.snp.bottom).offset(8)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().offset(-40)
        }
        keyboardManager = KeyboardManager(viewController: self, bottomConstraint: bottomViewBottomConstraint)
        newPassword.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        currentPassword.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        
        viewModel.$updatedUser.receive(on: DispatchQueue.main).sink { updatedUser in
            if let user = User.load(), let updatedUser = updatedUser {
                user.details = updatedUser.details
                user.save()
                MainHelper.showToastMessage(message: "Password updated successfully".localized, style: .success, position: .Bottom)
            }
        }.store(in: &cancellables)
        
        saveBtn.tap = {
            self.viewModel.changePassword(password: self.newPassword.text ?? "", mobile: User.load()?.details?.mobileNumber ?? "")
        }
    }

    
    @objc private func valueChanged(){
        if let password = self.currentPassword.text, isValidPassword(password) , let newPassword = self.newPassword.text, isValidPassword(newPassword){
            self.saveBtn.enableDisableSaveButton(isEnable: true)
        }else{
            self.saveBtn.enableDisableSaveButton(isEnable: false)
        }
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
