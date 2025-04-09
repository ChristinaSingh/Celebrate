//
//  SetupReadyViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/12/2024.
//

import Foundation
import UIKit
import SnapKit


class SetupReadyViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textAlignment = .center
        label.text = "\("Hi".localized) \(User.load()?.details?.fullName ?? "")"
        return label
    }()
    
    private let titleLbl:UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 24)
        label.textAlignment = .center
        label.text = "Your table is ready!".localized
        return label
    }()
    
    
    private let decorationImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "decoration")
        img.layer.cornerRadius = 8
        return img
    }()
    
    private let submitBtn:C8Button = {
        let btn = C8Button()
        btn.setTitle("Okay".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        [welcomeLabel, titleLbl, decorationImg, submitBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.welcomeLabel.snp.bottom).offset(8)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-37)
            make.height.equalTo(48)
        }
        
        decorationImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
            make.bottom.equalTo(self.submitBtn.snp.top).offset(-16)
        }
        
        submitBtn.tap {
            self.dismiss(animated: true)
        }
    }
}
