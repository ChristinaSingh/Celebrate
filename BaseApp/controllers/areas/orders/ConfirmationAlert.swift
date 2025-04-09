//
//  ConfirmationAlert.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/08/2024.
//

import Foundation
import UIKit
import SnapKit

class ConfirmationAlert: UIViewController {
    
    
    private let alertView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "postpone")
        return icon
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 24)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let proceedBtn:C8Button = {
        let btn = C8Button()
        btn.isActive = true
        btn.setTitle("Proceed".localized)
        btn.layer.cornerRadius = 24
        return btn
    }()
    
    
    private let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        btn.setTitleColor(UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1), for: .normal)
        btn.setTitle("Cancel".localized)
        return btn
    }()
    
    
    var titleStr:String?
    var message:String?
    var positiveButtonTitle:String?
    var withNigativeButton:Bool = true
    var negativeButtonTitle:String?
    var image:UIImage?
    var callback:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurredBackground()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
            make.height.equalTo(402)
        }
        
        titleLbl.text = titleStr
        messageLbl.text = message
        icon.image = image
        proceedBtn.setTitle(positiveButtonTitle)
        cancelBtn.setTitle(negativeButtonTitle)
        [icon, titleLbl, messageLbl, proceedBtn, cancelBtn].forEach { view in
            self.alertView.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            make.top.equalToSuperview().offset(40)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(24)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
        }
        
        proceedBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(self.messageLbl.snp.bottom).offset(24)
            make.height.equalTo(48)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.proceedBtn.snp.bottom).offset(24)
        }
        
        if !withNigativeButton {
            cancelBtn.isHidden = true
            cancelBtn.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.proceedBtn.snp.bottom).offset(24)
                make.height.equalTo(0)
            }
        }
        
        cancelBtn.tap {
            self.dismiss(animated: true)
        }
        
        proceedBtn.tap {
            self.dismiss(animated: true) {
                self.callback?()
            }
        }
    }
    
    private func setupBlurredBackground() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let colorOverlayView = UIView(frame: blurEffectView.bounds)
        colorOverlayView.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.7)
        colorOverlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(colorOverlayView)
    }
    
    class func show(on viewController: UIViewController , title:String , message:String, icon:UIImage? = UIImage(named: "postpone"), positiveButtonTitle:String = "Proceed".localized, negativeButtonTitle:String = "Cancel".localized, callback:(() -> ())? = nil, withNigativeButton:Bool = true) {
        let alert = ConfirmationAlert()
        alert.message = message
        alert.titleStr = title
        alert.image = icon
        alert.positiveButtonTitle = positiveButtonTitle
        alert.negativeButtonTitle = negativeButtonTitle
        alert.callback = callback
        alert.withNigativeButton = withNigativeButton
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        viewController.present(alert, animated: true, completion: nil)
    }
}
