//
//  ApplePayManager.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import TapApplePayKit_iOS
import PassKit

class ApplePayManager:NSObject, PKPaymentAuthorizationViewControllerDelegate{
   

    static let shared:ApplePayManager = .init()
    var delegate:ApplePayManagerDelegate?
    let applePayBtn:ApplePayButton = {
        let btn = ApplePayButton()
        btn.layer.cornerRadius = 24
        btn.backgroundColor = .black
        btn.title = "Pay with"
        return btn
    }()
    
    func setupApplePay(){
        TapApplePay.setupTapMerchantApplePay(merchantKey: SecretKey(sandbox: "pk_test_C2RwL5MJpSlAyd4mzDQ1bTN3", production: "sk_live_ENWG8zPYgRyf2Zn6MmJFHSvb"), merchantID: "mercahnt.com.celebrate.app") {
            print("success")
        } onErrorOccured: { error in
            print(error ?? "")
        }
        TapApplePay.sdkMode = .production
    }
   
    func initPayment(toPayAmount:Double, on viewController:UIViewController){
        applePayBtn.tap {
            self.authorisePayment(toPayAmount: toPayAmount, on: viewController)
        }
    }
    
    
    func authorisePayment(toPayAmount:Double, on viewController:UIViewController) {
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: toPayAmount))
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.com.celebrate.app"
        paymentRequest.supportedNetworks = [.visa, .masterCard]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "KW"
        paymentRequest.currencyCode = "KWD"
        paymentRequest.paymentSummaryItems = [total]
        if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            paymentVC.delegate = self
            viewController.present(paymentVC, animated: true, completion: nil)
        } else {
            delegate?.didFailApplePay("Unable to present Apple Pay authorization.")
        }
    }
    
    
    private func parseAppleResponse(with token:TapApplePayToken) {
        if let tokenData = token.stringAppleToken {
            let jsonData = Data(tokenData.utf8)
            let decoder = JSONDecoder()
            let response = try? decoder.decode(ApplePayTabResponse.self, from: jsonData)
            if let _ = response?.data {
                let data = tokenData.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
                self.delegate?.didFinishApplePay(data)
            }
        }
    }
        
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let tapAppleToken = TapApplePayToken.init(with:payment.token)
        self.parseAppleResponse(with: tapAppleToken)
        completion(PKPaymentAuthorizationResult(status: .success,errors: nil))
    }
    
    
}
