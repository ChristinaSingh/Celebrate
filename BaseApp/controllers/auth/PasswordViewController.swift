//
//  PasswordViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class PasswordViewController: BaseViewController, PasswordTextFieldDelegate {
    
    let service:Service
    let viewModel:AuthViewModel
    let username:String
    let phoneNum:String
    init(service: Service , username:String = "" , phoneNum:String = "") {
        self.service = service
        self.viewModel = AuthViewModel()
        self.username = username
        self.phoneNum = phoneNum
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
        lbl.text = "Create a password".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    private lazy var passwordTF:PasswordTextField = {
        let textfield = PasswordTextField()
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        textfield.tintColor = .white
        textfield.textColor = .white
        textfield.passwordDelegate = self
        return textfield
    }()
    
    
    private let passwordDesc:C8Label = {
        let lbl = C8Label()
        lbl.text = "password_desc".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 13)
        lbl.textColor = UIColor.white.withAlphaComponent(0.5)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    
    private let forgetPasswordBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Forgot password?".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 13)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    
    private lazy var proceedBtn:LoadingButton = {
        return LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
    }()

    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    private let resetPasswordLoadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        return indicator
    }()
    
    override func setup() {
        IQKeyboardManager.shared.disabledToolbarClasses.append(PasswordViewController.self)
        view.backgroundColor = UIColor(named: "AccentColor")
        changeTitles()
        
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [back , titleLbl , messageLbl , passwordTF, passwordDesc, forgetPasswordBtn, resetPasswordLoadingIndicator, proceedBtn].forEach { view in
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
        
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(self.messageLbl.snp.bottom).offset(70.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.centerX.equalToSuperview()
            make.height.equalTo(50.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        passwordDesc.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.passwordTF.snp.bottom).offset(52)
        }
        
        forgetPasswordBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.passwordTF.snp.bottom).offset(52)
        }
        resetPasswordLoadingIndicator.isHidden = true
        resetPasswordLoadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.passwordTF.snp.bottom).offset(52)
        }
        
        proceedBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-200.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        passwordTF.becomeFirstResponder()
    }
    
    
    private func changeTitles(){
        switch service {
        case .Login:
            titleLbl.text = "Login".localized
            forgetPasswordBtn.isHidden = false
            passwordDesc.isHidden = true
            forgetPasswordBtn.isUserInteractionEnabled = true
            messageLbl.text = "Enter password".localized
        case .Register:
            titleLbl.text = "Register".localized
            forgetPasswordBtn.isHidden = true
            passwordDesc.isHidden = false
            forgetPasswordBtn.isUserInteractionEnabled = false
            messageLbl.text = "Create a password".localized
        case .ForgetPassword:
            titleLbl.text = "Forgot password?".localized
            forgetPasswordBtn.isHidden = true
            passwordDesc.isHidden = false
            forgetPasswordBtn.isUserInteractionEnabled = false
            messageLbl.text = "Create a password".localized
            break
        case .contactus, .UpdatePhone, .UpdateEmail, .BookedPlanner, .PlanEvent, .Surprise, .Rate , .none:
            break
        }
    }
    
    override func keyboardOpened(with height: CGFloat) {
        proceedBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-height)
        }
    }
    
    
    override func actions() {
        back.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        proceedBtn.tap = {
            if self.service == .Login {
                self.viewModel.login(playerId:  UserDefaults.standard.string(forKey: "playerId") ?? "", mobile: self.phoneNum, password: self.passwordTF.text ?? "")
            }else if self.service == .Register{
                self.viewModel.newUser(username: self.username, mobile: self.phoneNum, password: self.passwordTF.text ?? "", playerId: UserDefaults.standard.string(forKey: "playerId") ?? "")
            }else if self.service == .ForgetPassword{
                self.viewModel.changePassword(password: self.passwordTF.text ?? "", mobile: self.phoneNum)
            }
        }
        
        forgetPasswordBtn.tap {
            self.viewModel.resetPassword(mobile: self.phoneNum)
        }
    }
    
    
    func password(_ isValid: Bool) {
        proceedBtn.setActive(isValid)
    }
    
    
    override func observers() {
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink(receiveValue: { isLoading in
            self.views(isLoading , self.back , self.passwordTF)
            self.proceedBtn.loading(isLoading)
        }).store(in: &cancellables)
        
        
        self.viewModel.$forgetPasswordLoading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.resetPasswordLoadingIndicator.isHidden = false
                self.forgetPasswordBtn.isHidden = true
                self.proceedBtn.isUserInteractionEnabled = false
                self.back.isUserInteractionEnabled = false
            }else{
                self.resetPasswordLoadingIndicator.isHidden = true
                self.forgetPasswordBtn.isHidden = false
                self.proceedBtn.isUserInteractionEnabled = true
                self.back.isUserInteractionEnabled = true
            }
        }.store(in: &cancellables)
        
        
        self.viewModel.$resetPassword.dropFirst().receive(on: DispatchQueue.main).sink { res in
            guard let res, let token = res.token, !token.isBlank else { return }
            self.navigationController?.pushViewController(VerifyMobileViewController(phoneNum: self.phoneNum, service: .ForgetPassword, authToken: token), animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error) { statusCode, _ in
                if statusCode == 403{
                    MainHelper.showToastMessage(message: "Invalid API Key".localized, style: .error, position: .Top)
                }else if statusCode == 401 {
                    MainHelper.showToastMessage(message: "Incorrect mobile number or password".localized, style: .error, position: .Top)
                } else if statusCode == 400{
                    if let error = error as? ErrorResponse{
                        switch error {
                        case .error(_,  let data, _):
                            if let data = data {
                                let decodedObj =  CodableHelper.decode(AppResponse.self, from: data)
                                if let response = decodedObj.decodableObj, let message = response.message {
                                    MainHelper.showToastMessage(message: message, style: .error, position: .Top)
                                }
                            }
                        }
                    }else{
                        MainHelper.showToastMessage(message: "Somthing went wrong".localized, style: .error, position: .Top)
                    }
                    
                }
            }
        }.store(in: &cancellables)
        
        
        self.viewModel.$loggedIn.dropFirst().receive(on: DispatchQueue.main).sink { user in
            if let user = user{
                user.save()
                self.navigationController?.pushViewController(AuthWelcomeViewController(service: self.service), animated: true)
            }
        }.store(in: &cancellables)
        
        
        self.viewModel.$newPassword.dropFirst().receive(on: DispatchQueue.main).sink {  user in
            if let _ = user, let vc = self.navigationController?.viewControllers.first(where: { vc in
                vc is MobileNumberViewController
            }){
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }.store(in: &cancellables)
    }

}
