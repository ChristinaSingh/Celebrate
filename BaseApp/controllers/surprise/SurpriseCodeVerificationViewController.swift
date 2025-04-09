//
//  SurpriseCodeVerificationViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/10/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class SurpriseCodeVerificationViewController: VerifyMobileViewController {
    
    private let viewModel:SurpriseViewModel = SurpriseViewModel()
    private var otp:String = ""
    
    override func setup() {
        super.setup()
        otpView.keyboardType = .asciiCapable
        titleLbl.text = ""
        messageLbl.text = "Enter the code".localized
        verificationNumDesc.text = ""
        timer.stop()
        resendBtn.setTitle("Done".localized)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resendBtn.setTitle("Done".localized)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpView.requestFocus()
    }
    
    override func observers() {
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink(receiveValue: { isLoading in
            self.resendBtn.loading(isLoading)
        }).store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            guard let _ = error else { return }
            MainHelper.handleApiError(error) { statusCode, _ in
                if statusCode == 401{
                    if let error = error as? ErrorResponse{
                        switch error {
                        case .error(_,  let data, _):
                            if let data = data {
                                let decodedObj =  CodableHelper.decode(AppResponse.self, from: data)
                                if let response = decodedObj.decodableObj{
                                    if response.status?.string.uppercased() == "ALREADYPLAYED".uppercased()  {
                                        MainHelper.showToastMessage(message: "already redeemed".localized, style: .error, position: .Top)
                                    }else{
                                        MainHelper.showToastMessage(message: "invalid_code".localized, style: .error, position: .Top)
                                    }
                                }else{
                                    MainHelper.showToastMessage(message: "invalid_code".localized, style: .error, position: .Top)
                                }
                            }
                        }
                    }else{
                        MainHelper.showToastMessage(message: "invalid_code".localized, style: .error, position: .Top)
                    }
                    
                }else if statusCode == 400{
                    MainHelper.showToastMessage(message: "Somthing went wrong".localized, style: .error, position: .Top)
                }
            }
        }.store(in: &cancellables)
        
        
        self.viewModel.$state.dropFirst().receive(on: DispatchQueue.main).sink { res in
            if res?.customerstartedgame == 0 {
                self.start()
            }else{
                self.continueGame()
            }
        }.store(in: &cancellables)
        
        self.viewModel.$verifyCodeResponse.dropFirst().receive(on: DispatchQueue.main).sink { response in
            if let res = response {
                if res.status?.string.uppercased() == "ALREADYPLAYED".uppercased()  {
                    MainHelper.showToastMessage(message: "already redeemed".localized, style: .error, position: .Top)
                }else if res.status?.string.uppercased() == "success".uppercased(){return}
                else {
                    MainHelper.showToastMessage(message: "invalid_code".localized, style: .error, position: .Top)
                }
            }
        }.store(in: &cancellables)
    }
    
    
    private func start(){
        let vc = SurpriseOnBoardingViewController(onboardingType: .Basic)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func continueGame(){
        let vc = SurpriseQuestionsVewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    override func entered(text: String) {
        self.otp = text
        self.viewModel.verifyAndGetState(code: text)
        resendBtn.setActive(true)
        self.view.endEditing(true)
    }
    
    
    override func actions() {
        resendBtn.tap = {
            self.viewModel.verifyAndGetState(code: self.otp)
        }
    }
}
