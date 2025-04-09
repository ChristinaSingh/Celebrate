//
//  CartExpiredViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import SnapKit
import UIKit

class ExpiredViewController:UIViewController {
    
    
    let titleStr:String
    let message:String
    init(titleStr: String, message: String, callback: ( () -> Void)? = nil) {
        self.titleStr = titleStr
        self.message = message
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let icon:UIImageView = {
        let img = UIImageView()
        img.image = .error
        return img
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    private let proceedBtn:C8Button = {
        let btn = C8Button()
        btn.layer.cornerRadius = 24
        btn.isActive = true
        btn.setTitle("Proceed".localized)
        return btn
    }()
    
    var callback:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        titleLbl.text = titleStr
        messageLbl.text = message
        [icon, titleLbl, messageLbl, proceedBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(40)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(16)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
        
        proceedBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(messageLbl.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(48)
        }
        
        proceedBtn.tap {
            self.dismiss(animated: true) {
                self.callback?()
            }
        }
    }
    
}
