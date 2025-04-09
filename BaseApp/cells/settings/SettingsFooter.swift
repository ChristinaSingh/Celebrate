//
//  SettingsFooter.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit

class SettingsFooter: UITableViewHeaderFooterView {
    
    let deleteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete my account permanently".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        btn.setTitleColor(UIColor(red: 1, green: 0.22, blue: 0.502, alpha: 1), for: .normal)
        return btn
    }()
    
    
    let appVersionLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    let activityIndiactor:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        self.backgroundColor = .white
        [deleteBtn, appVersionLbl, activityIndiactor].forEach { view in
            self.addSubview(view)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        activityIndiactor.stopAnimating()
        activityIndiactor.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        appVersionLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.deleteBtn.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
}
