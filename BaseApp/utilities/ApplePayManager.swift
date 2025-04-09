//
//  ApplePayManager.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import TapApplePayKit_iOS


struct ApplePayTabResponse: Codable {
    let data, signature: String?
    let header: Header?
    let version: String?
}

// MARK: - Header
struct Header: Codable {
    let publicKeyHash, ephemeralPublicKey, transactionID: String?

    enum CodingKeys: String, CodingKey {
        case publicKeyHash, ephemeralPublicKey
        case transactionID = "transactionId"
    }
}

protocol ApplePayManagerDelegate {
    func didFinishApplePay(_ response: String)
    func didFailApplePay(_ error: String)
}


class ApplePayManager:NSObject, TapApplePayButtonDataSource,TapApplePayButtonDelegate{
    var delegate:ApplePayManagerDelegate?
    private let c8TapApplePayRequest:TapApplePayRequest = .init()
    private let tapApplePay:TapApplePay = .init()
    private let applePayBtn:TapApplePayButton = {
        let btn = TapApplePayButton()
        return btn
    }()
    
    private func applePayButton() -> TapApplePayButton {
        return applePayBtn
    }
    
    
    func applePayment(toPayAmount:Double, on viewController:UIViewController){
        c8TapApplePayRequest.build(paymentNetworks: [.MasterCard , .Visa , .Amex], paymentItems: [], paymentAmount: toPayAmount , currencyCode: .KWD,merchantID:"merchant.com.celebrate.app", merchantCapabilities: [.capability3DS])
        applePayBtn.delegate = self
        applePayBtn.dataSource = self
        applePayBtn.setup(tapApplePayButtonClicked: { btn in
            DispatchQueue.main.async {
                self.authorisePayment(on: viewController)
            }
        })
    }
    
    
    private  func authorisePayment(on viewController:UIViewController) {
        tapApplePay.authorizePayment(in: viewController, for: c8TapApplePayRequest) { [weak self] (token) in
            self?.parseAppleResponse(with: token)
        } onErrorOccured: { error in
            self.delegate?.didFailApplePay(error.TapApplePayRequestValidationErrorRawValue())
        }
    }
    
    
    internal func tapApplePayValidationError(error: TapApplePayRequestValidationError) {
        delegate?.didFailApplePay(error.TapApplePayRequestValidationErrorRawValue())
    }
    
    internal var tapApplePayRequest: TapApplePayRequest {
        return c8TapApplePayRequest
    }
    
    internal func tapApplePayFinished(with tapAppleToken: TapApplePayToken) {
        parseAppleResponse(with: tapAppleToken)
    }
    
    
    private func parseAppleResponse(with token:TapApplePayToken) {
        if let tokenData = token.stringAppleToken {
            let jsonData = Data(tokenData.utf8)
            let decoder = JSONDecoder()
            let response = try? decoder.decode(ApplePayTabResponse.self, from: jsonData)
            if let token = response?.data {
                let data = tokenData.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
                self.delegate?.didFinishApplePay(data)
            }
        }
    }
    
}
