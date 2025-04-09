//
//  VerifyMobileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/03/2024.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class VerifyMobileViewController: BaseViewController, TimerDelegate , OTPDidEnteredDelegate {
   
    private let phoneNum:String
    private let service:Service
    let timer:TimerManager
    private let viewModel:AuthViewModel
    private let time:Int = 300
    static var authToken:String?
    init(phoneNum: String, service: Service, authToken:String? = nil) {
        self.phoneNum = phoneNum
        self.service = service
        self.timer = TimerManager()
        VerifyMobileViewController.authToken = authToken
        self.viewModel = AuthViewModel()
        super.init(nibName: nil, bundle: nil)
        timer.delegate = self
    }
    
    init() {
        self.phoneNum = ""
        self.service = .none
        self.timer = TimerManager()
        self.viewModel = AuthViewModel()
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
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Register".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        return lbl
    }()
    
    
    let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Verify your number".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    let otpView:OTPView = {
        let view = OTPView()
        return view
    }()
    
    
    let verificationNumDesc:C8Label = {
        let lbl = C8Label()
        lbl.text = "Verification code sent to".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 13)
        lbl.textColor = UIColor.white.withAlphaComponent(0.5)
        return lbl
    }()
    
    lazy var resendBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Resend in".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        //btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(false)
        return btn
    }()

    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    override func setup() {
        IQKeyboardManager.shared.disabledToolbarClasses.append(VerifyMobileViewController.self)
        changeTitles()
        view.backgroundColor = self.service == .UpdatePhone ? .white : .accent
        if self.service == .UpdatePhone {
            self.back.setImage(UIImage(named: "back_black"), for: .normal)
            self.titleLbl.textColor = .black
            self.otpView.color = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
            self.verificationNumDesc.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
            self.resendBtn.loadingView.color = .white
            self.resendBtn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        }else{
            self.view.addSubview(backgroundView)
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        [back , titleLbl , messageLbl , otpView , verificationNumDesc, resendBtn].forEach { view in
            if self.service == .UpdatePhone {
                self.view.addSubview(view)
            }else{
                self.backgroundView.addSubview(view)
            }
        }
        verificationNumDesc.text = "Verification code sent to".localized + phoneNum
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
        otpView.delegate = self
        otpView.snp.makeConstraints { make in
            make.top.equalTo(self.messageLbl.snp.bottom).offset(70.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.centerX.equalToSuperview()
            make.height.equalTo(50.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        verificationNumDesc.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.otpView.snp.bottom).offset(56.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        resendBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-30.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        back.tap {
            self.navigationController?.popViewController(animated: true)
        }
        

        otpView.requestFocus()
        timer.start(with: time)
    
    }
    
    private func changeTitles(){
        switch service {
        case .Login:
            titleLbl.text = "Login".localized
            messageLbl.text = "Verify your number".localized
        case .Register:
            titleLbl.text = "Register".localized
            messageLbl.text = "Verify your number".localized
        case .ForgetPassword:
            titleLbl.text = "Forgot password?".localized
            messageLbl.text = "Verify number to reset password".localized
            break
        case .UpdatePhone:
            titleLbl.text = "Verify number".localized
            messageLbl.text = "Verify your number".localized
        default:
            break
        }
    }
    
    override func keyboardOpened(with height: CGFloat) {
        resendBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-height)
        }
    }
    
    override func keyboardClosed(with height: CGFloat) {
        resendBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-37)
        }
    }
    
    override func observers() {
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink(receiveValue: { isLoading in
            self.views(isLoading , self.back , self.otpView)
            self.resendBtn.loading(isLoading)
        }).store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            guard let _ = error else { return }
            self.timer.restart()
            self.resendBtn.loading(false)
            self.resendBtn.setActive(false)
            MainHelper.handleApiError(error) { statusCode, _ in
                if statusCode == 403{
                    MainHelper.showToastMessage(message: "Invalid API Key".localized, style: .error, position: .Top)
                }else if statusCode == 400{
                                 
                    let vc = UsernameViewController(phoneNum: self.phoneNum)
                    self.navigationController?.pushViewController(vc, animated: true)

//                    MainHelper.showToastMessage(message: "Somthing went wrong".localized, style: .error, position: .Top)
                }else {
                    if let error = error as? ErrorResponse{
                        switch error {
                        case .error(_,  let data, _):
                            if let data = data {
                                let decodedObj =  CodableHelper.decode(AppResponse.self, from: data)
                                if let response = decodedObj.decodableObj, let message = response.message {
                                    MainHelper.showToastMessage(message: message, style: .error, position: .Bottom)
                                }
                            }
                        }
                    }
                }
            }
        }.store(in: &cancellables)
        
        
        self.viewModel.$resendOtp.dropFirst().receive(on: DispatchQueue.main).sink { otp in
            if otp?.message?.lowercased() == "New OTP sent successfully".lowercased(){
                self.timer.start(with: self.time)
            }else if let data = otp?.data{
                MainHelper.showToastMessage(message: data, style: .error, position: .Top)
            }
        }.store(in: &cancellables)
        
        viewModel.$updatedUser.dropFirst().receive(on: DispatchQueue.main).sink { updatedUser in
            if let user = User.load(), let updatedUser = updatedUser {
                user.details = updatedUser.details
                user.save()
                let vc = AuthWelcomeViewController(service: .UpdatePhone)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.store(in: &cancellables)
        
        self.viewModel.$verifyOtp.dropFirst().receive(on: DispatchQueue.main).sink { otp in
            if otp?.status?.boolean == true {
                self.timer.stop()
                switch self.service {
                case .Login:
                    let vc = PasswordViewController(service: self.service, phoneNum: self.phoneNum)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .Register:
                    let vc = UsernameViewController(phoneNum: self.phoneNum)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .ForgetPassword:
                    let vc = PasswordViewController(service: .ForgetPassword, phoneNum: self.phoneNum)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .UpdatePhone:
                    guard let user = User.load(), let details = user.details else{return}
                    self.viewModel.updateProfile(name: details.fullName, email: details.email, mobile: self.phoneNum, birthday: details.birthday, username: details.username, ispublic: details.ispublic)
                    break
                default:
                    break
                }
            }else if let data = otp?.data{
                
//                let vc = UsernameViewController(phoneNum: self.phoneNum)
//                self.navigationController?.pushViewController(vc, animated: true)

                self.timer.restart()
                MainHelper.showToastMessage(message: data, style: .error, position: .Top)
            }
        }.store(in: &cancellables)
    }
    
    override func actions() {
        resendBtn.tap = {
            self.viewModel.resendOtp(body: OtpVerificationBody(mobile: self.phoneNum , channel: "SMS" , action: self.service.rawValue))
        }
    }
    
    func runing(time: Int) {
        if time < 0 { return }
        resendBtn.setActive(false)
        resendBtn.setTitle("Resend in".localized + "\(time.formatSecondsToTimerString())")
    }
    
    func finished() {
        resendBtn.setActive(true)
        resendBtn.setTitle("Resend".localized)
    }
    
    ///api/v3/customer/verifyotp

    func entering() {
        resendBtn.setActive(false)
    }
    
    func entered(text: String) {
        self.timer.stop()
        resendBtn.setActive(true)
        viewModel.verifyOtp(body: OtpVerificationBody(mobile: self.phoneNum, channel: "SMS", action: service.rawValue, otp: text))
        self.view.endEditing(true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
//        cancellables.forEach { it in
//            it.cancel()
//        }
//        viewModel.dinit()
    }
}
