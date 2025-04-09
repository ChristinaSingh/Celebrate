//
//  SheetPresenter.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/08/2024.
//

import Foundation
import UIKit


class SheetPresenter: NSObject {
    
    static let shared = SheetPresenter()
    
    func presentSheet(_ bottomSheetVC: UIViewController, on viewController: UIViewController, height:CGFloat , isCancellable: Bool = true) {
        bottomSheetVC.view.layer.cornerRadius = 16
        bottomSheetVC.isModalInPresentation = !isCancellable
        if #available(iOS 16.0, *) {
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [
                    .custom { context in
                        return height
                    }
                ]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = isCancellable
                sheet.prefersEdgeAttachedInCompactHeight = !isCancellable
                sheet.prefersGrabberVisible = true
            }
            viewController.present(bottomSheetVC, animated: true, completion: nil)
        } else {
            let configuration = NBBottomSheetConfiguration(animationDuration: 0.4, sheetSize: .fixed(height))
            let bottomSheetController = NBBottomSheetController(configuration: configuration)
            bottomSheetController.present(bottomSheetVC, on: viewController)
        }
    }
}
