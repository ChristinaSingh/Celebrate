//
//  UsernameViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/03/2024.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class UsernameViewController: BaseViewController, UsernameTextFieldDelegate {
    
    
    private let phoneNum:String
    let viewModel:AuthViewModel
  
    init(phoneNum: String) {
        self.phoneNum = phoneNum
        viewModel = AuthViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let back:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: .normal)
        return btn
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Register".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Create a username".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    private lazy var username:C8TextField = {
        let textfield = C8TextField()
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        textfield.tintColor = .white
        textfield.textColor = .white
        textfield.userNameDelegate = self
        textfield.text = "@"
        return textfield
    }()
    
    
    private lazy var proceedBtn:LoadingButton = {
        return LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
    }()
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    override func setup() {
        IQKeyboardManager.shared.disabledToolbarClasses.append(UsernameViewController.self)
        view.backgroundColor = UIColor(named: "AccentColor")
        
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [back , titleLbl , messageLbl , username, proceedBtn].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        back.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.back.snp.centerY)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(65.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(self.messageLbl.snp.bottom).offset(70.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.centerX.equalToSuperview()
            make.height.equalTo(50.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
    
        proceedBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-200.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        username.becomeFirstResponder()
    }
    
    override func keyboardOpened(with height: CGFloat) {
        proceedBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-height)
        }
    }
    
    
    override func actions() {
        proceedBtn.tap = {
            if ExcludedUserNamesManager.shared.isUserNameAcceptted(username: self.username.text?.replacingOccurrences(of: "@", with: "") ?? "") {
                self.viewModel.checkIfUserNameExists(username: self.username.text?.replacingOccurrences(of: "@", with: "") ?? "")
            }
        }
        
        back.tap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func username(_ isValid: Bool) {
        proceedBtn.setActive(isValid)
    }

    
    override func observers() {
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink(receiveValue: { isLoading in
            self.views(isLoading , self.back , self.username)
            self.proceedBtn.loading(isLoading)
        }).store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error) { statusCode, _ in
                if statusCode == 403{
                    MainHelper.showToastMessage(message: "Invalid API Key".localized, style: .error, position: .Top)
                }else if statusCode == 400{
                    MainHelper.showToastMessage(message: "Somthing went wrong".localized, style: .error, position: .Top)
                }
            }
        }.store(in: &cancellables)
        
        self.viewModel.$checkIfUserNameExists.dropFirst().receive(on: DispatchQueue.main).sink { otp in
            if otp?.status?.boolean == false && otp?.message?.lowercased() == "success".lowercased(){
                self.navigationController?.pushViewController(PasswordViewController(service: .Register , username: self.username.text?.replacingOccurrences(of: "@", with: "") ?? "" , phoneNum: self.phoneNum), animated: true)
            }else if let data = otp?.data{
                MainHelper.showToastMessage(message: data, style: .error, position: .Top)
            }
        }.store(in: &cancellables)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        cancellables.forEach { it in
//            it.cancel()
//        }
//        viewModel.dinit()
    }
}
