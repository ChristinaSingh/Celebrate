//
//  MobileNumberViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/03/2024.
//


import Foundation
import UIKit
import SnapKit
import Combine
import IQKeyboardManagerSwift
import AuthenticationServices
import Firebase
import GoogleSignIn

class MobileNumberViewController:BaseViewController,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    let service:Service
    let viewModel:AuthViewModel
    
    init(service: Service) {
        self.service = service
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
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Register".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Whats your phone number?".localized
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    private let countryView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.365, green: 0.09, blue: 0.922, alpha: 0.5).cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        return view
    }()
    
    
    private let countryCodeLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "🇰🇼 +965"
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    private let phoneNumTF:UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.borderStyle = .none
        textfield.textAlignment = .left
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .clear
        textfield.textColor = .white
        textfield.tintColor = .white
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 35)
        return textfield
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
     //   button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        let image = UIImage(named: "Apple (2)")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
     //   button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.tintColor = .white
        button.contentHorizontalAlignment = .center

        return button
    }()

    
    let googleLoginButton: UIButton = {
        let button = UIButton()
     //   button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        let image = UIImage(named: "google (3)")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
       // button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return button
    }()

    private let termsLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "By continuing, you agree to our Privacy Policy and\nTerms of Service.".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        lbl.textColor = .white
        lbl.alpha = 0.5
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    private lazy var proceedBtn:LoadingButton = {
        return LoadingButton.createObject(title: "Send verification text".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
    }()
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    override func setup() {
    
        view.backgroundColor = UIColor(named: "AccentColor")
        self.view.addSubview(backgroundView)
    
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
       // IQKeyboardManager.shared.disabledToolbarClasses.append(MobileNumberViewController.self)
     
        changeTitles()
      
        [back , titleLbl , messageLbl , countryView , phoneNumTF , termsLbl , proceedBtn,orLabel,appleLoginButton,googleLoginButton].forEach { view in
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

      

        countryView.snp.makeConstraints { make in
            if AppLanguage.isArabic() {
                make.trailing.equalToSuperview().offset(-48.constraintMultiplierTargetValue.relativeToIphone8Width())
            }else{
                make.leading.equalToSuperview().offset(48.constraintMultiplierTargetValue.relativeToIphone8Width())
            }
            make.width.equalTo(78)
            make.height.equalTo(40)
            make.top.equalTo(self.messageLbl.snp.bottom).offset(52)
        }
        
        phoneNumTF.snp.makeConstraints { make in
            make.centerY.equalTo(self.countryView.snp.centerY)
            if AppLanguage.isArabic() {
                make.trailing.equalTo(self.countryView.snp.leading).offset(-12)
                make.leading.equalToSuperview().offset(48.constraintMultiplierTargetValue.relativeToIphone8Width())
            }else{
                make.leading.equalTo(self.countryView.snp.trailing).offset(12)
                make.trailing.equalToSuperview().offset(-48.constraintMultiplierTargetValue.relativeToIphone8Width())
            }
        }
        
        termsLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.phoneNumTF.snp.bottom).offset(52)
        }
        
        
        proceedBtn.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        orLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(proceedBtn.snp.bottom).offset(20)
        }

        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(proceedBtn.snp.bottom).offset(50)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.width.height.equalTo(50)
      
        }
              
         
              
        googleLoginButton.snp.makeConstraints { make in
            make.centerY.equalTo(appleLoginButton)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.width.height.equalTo(50)

        }
//        googleLoginButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(orLabel.snp.bottom).offset(10)
//            make.width.equalTo(proceedBtn)
//            make.height.equalTo(50)
//        }
//
//        appleLoginButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(googleLoginButton.snp.bottom).offset(10)
//            make.width.equalTo(proceedBtn)
//            make.height.equalTo(50)
//        }

    //    phoneNumTF.becomeFirstResponder()
        
        countryView.addSubview(countryCodeLbl)
        countryCodeLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        phoneNumTF.delegate = self
        
        appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)

    }
    
    @objc func handleAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // You can now send this info to your backend
            print("Apple User ID: \(userIdentifier)")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
    
    // MARK: - Google Login
    @objc private func handleGoogleLogin() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
             if let error = error {
                 print("Sign-in error: \(error.localizedDescription)")
                 return
             }
             
             guard let user = result?.user else {
                 print("Sign-in result is nil")
                 return
             }
             
             let userId = user.userID ?? "No user ID"
             let userName = user.profile?.name ?? "No name"
             let userEmail = user.profile?.email ?? "No email"
             
             let profilePicURL: String?
             if let url = user.profile?.imageURL(withDimension: 100) {
                 profilePicURL = url.absoluteString
             } else {
                 profilePicURL = nil
             }
             
             let idToken = user.idToken?.tokenString ?? ""
            let accessToken = user.accessToken.tokenString
             
             guard !idToken.isEmpty, !accessToken.isEmpty else {
                 print("ID token or access token is empty")
                 return
             }
             
            print("\(userId) -- \(userName)  -- \(userEmail)  -- \(profilePicURL)")
            
            let vc = UpdateSocialVC(service: .Login)
            vc.imageUrl = profilePicURL!
            vc.Username = userName
            vc.email = userEmail

            self.navigationController?.pushViewController(vc, animated: true)

//             self.saveGoogleUserData(userID: userId, userName: userName, userEmail: userEmail, profilePicURL: profilePicURL, idToken: idToken, accessToken: accessToken)
             
//             DispatchQueue.main.async {
//                 NavigationHelper.shared.navigateToViewController(withIdentifier: "MainTabBarController", from: self)
//             }
         }

    }

    private func changeTitles(){
        switch service {
        case .Login:
            titleLbl.text = "Login".localized
        case .Register:
            titleLbl.text = "Register".localized
        case .ForgetPassword:
            break
        default:
            break
        }
    }
    //api/v3
    
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
            self.viewModel.checkIfMobileNumberExists(phoneNumber: self.phoneNumTF.text ?? "" , otpRequired: self.service == .Register)
        }
        
    }
    
    override func observers() {
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink(receiveValue: { isLoading in
            self.views(isLoading , self.back , self.phoneNumTF)
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
        
        self.viewModel.$checkIfMobileNumberExists.dropFirst().receive(on: DispatchQueue.main).sink { otp in
            if otp?.status?.boolean == false && otp?.message?.lowercased() == "success".lowercased() {
                self.navigationController?.pushViewController(VerifyMobileViewController(phoneNum: self.phoneNumTF.text ?? "", service: .Register), animated: true)
            }else if otp?.status?.boolean == true && otp?.message?.lowercased() == "success".lowercased(){
                self.navigationController?.pushViewController(PasswordViewController(service:  .Login , phoneNum: self.phoneNumTF.text ?? ""), animated: true)
            }else if let data = otp?.data{
                MainHelper.showToastMessage(message: data, style: .error, position: .Top)
            }
        }.store(in: &cancellables)
    }
    
    //https://github.com/swagger-api/swagger-codegen
   
    override func viewDidDisappear(_ animated: Bool) {
//        cancellables.forEach { it in
//            it.cancel()
//        }
//        viewModel.dinit()
    }
    
}

extension MobileNumberViewController:UITextFieldDelegate {
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty {
                return true
            }else if updatedText.count < 8 {
                self.proceedBtn.setActive(false)
            }else{
                self.proceedBtn.setActive(true)
            }
            return InputsValidator.isValidMobileNumber(updatedText) && updatedText.count <= 8
        }
        return false
    }
}
