//
//  AddEmailAddressViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit
import Combine

class AddEmailAddressViewController: UIViewController {

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
        let view = HeaderViewWithCancelButton(title: "Add email address".localized)
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
    
    private let emailLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Email address".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()

    
    lazy private var emailTF:C8TextField = {
        let password = C8TextField()
        password.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        password.delegate = nil
        password.isUserName = false
        password.isPassword = false
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
        
        [emailLbl, emailTF].forEach { view in
            self.contentView.addSubview(view)
        }
        
        emailLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(18)
        }
        
        
        emailTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.emailLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-40)
        }
        emailTF.text = User.load()?.details?.email
        emailTF.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        keyboardManager = KeyboardManager(viewController: self, bottomConstraint: bottomViewBottomConstraint)
        
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        
        viewModel.$updatedUser.receive(on: DispatchQueue.main).sink { updatedUser in
            if let user = User.load(), let updatedUser = updatedUser {
                user.details = updatedUser.details
                user.save()
                self.dismiss(animated: true) {
                    MainHelper.showToastMessage(message: "Email added successfully".localized, style: .success, position: .Bottom)
                }
            }
        }.store(in: &cancellables)
        
        saveBtn.tap = {
            if let user = User.load()?.details {
                self.viewModel.updateProfile(name: user.fullName, email: self.emailTF.text ?? "", mobile: user.mobileNumber, birthday: user.birthday, username: user.username, ispublic: user.ispublic)
            }
        }
    }
    
    
    @objc private func valueChanged(){
        if let email = self.emailTF.text, InputsValidator.isValidEmail(email) {
            self.saveBtn.enableDisableSaveButton(isEnable: true)
        }else{
            self.saveBtn.enableDisableSaveButton(isEnable: false)
        }
    }

}
