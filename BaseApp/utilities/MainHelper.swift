//
//  MainHelper.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/04/2024.
//

import Foundation
import UIKit



class MainHelper: NSObject {
    
    
    class func handleApiError(_ error:Error? , completion:((Int, String?) -> ())? = nil){
        DispatchQueue.main.async {
            if let error = error as? ErrorResponse{
                switch error {
                case .error(let code,  let data, _):
                    if completion != nil {
                        if let data = data{
                            if let message = CodableHelper.decode([String].self, from: data).decodableObj?.first {
                                completion?(code, message)
                            }else if let response = CodableHelper.decode(AppResponse.self, from: data).decodableObj, let message = response.message {
                                completion?(code, message)
                            }else{
                                completion?(code, nil)
                            }
                        }else{
                            completion?(code, nil)
                        }
                        
                    }else{
                        switch code {
                        case 403:
                            let vc = IntroViewController()
                            let nav = UINavigationController(rootViewController: vc)
                            nav.setNavigationBarHidden(true, animated: false)
                            if let sceneDelegate = UIApplication.shared.connectedScenes
                                .first?.delegate as? SceneDelegate {
                                sceneDelegate.changeRootViewController(nav)
                                let sessionVc = ExpiredViewController(titleStr: "Session Expired".localized, message: "Your session has been expired".localized) {
                                    User.remove()
                                }
                                SheetPresenter.shared.presentSheet(sessionVc, on: nav, height: 234, isCancellable: false)
                            }
                            break
                        case 406:
                            break
                        case 500:
                            if let topViewController = UIApplication.shared.topMostViewController() {
                                let sessionVc = ExpiredViewController(titleStr: "Server Error".localized,
                                                                      message: "An unexpected error occurred on our server. Please try again later, and if the issue persists, contact support.".localized) {}
                                
                                SheetPresenter.shared.presentSheet(sessionVc, on: topViewController, height: 234, isCancellable: true)
                            }
                            break
                        default:
                            if let data = data {
                                if let message = CodableHelper.decode([String].self, from: data).decodableObj?.first {
                                    showToastMessage(message: message, style: .error, position: .Bottom)
                                    completion?(code, message)
                                }else if let response = CodableHelper.decode(AppResponse.self, from: data).decodableObj, let message = response.message {
                                    showToastMessage(message: message, style: .error, position: .Bottom)
                                    completion?(code, message)
                                }
                            }
                            break
                        }
                    }
                }
            }else{
                showErrorMessage(message: "".localized) // add error message
            }
        }
    
    }
    
    
    class func showErrorMessage(message:String , isToast:Bool = false){
        DispatchQueue.main.async {
            if isToast {
                showToastMessage(message: message, style: .error, position: .Bottom)
            }
        }
    }
    
    
    class func showToastMessage(message:String , style:BannerStyle , position:BannerPosition){
        DispatchQueue.main.async {
            ToastBanner.shared.show(message: message, style: style, position: position)
        }
    }
    
    
}
