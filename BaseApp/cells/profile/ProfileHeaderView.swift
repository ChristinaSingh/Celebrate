//
//  ProfileHeaderView.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/11/2024.
//

import Foundation
import UIKit
import SnapKit


enum HeaderAction {
    case settings
    case notifications
    case editProfile
    case favorite
    case celebrations
}

class ProfileHeaderView: UICollectionReusableView {
    
    
    static let identifier = "ProfileHeaderView"
    
    private let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        return view
    }()
    
    private let settings:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Settings_header"), for: .normal)
        return btn
    }()
    
    private let notificationsBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Notifications"), for: .normal)
        return btn
    }()
    
    
    private let profileImg:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 40
        img.clipsToBounds = true
        img.image = UIImage(named: "avatar_details")
        img.backgroundColor = .white
        return img
    }()
    
    
    let userNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        return lbl
    }()

    
    
    let numberLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = .white
        return lbl
    }()
    
    
    
    private let verifiedIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "verified")
        return img
    }()
    
    
    let profileTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 1)
        return lbl
    }()
    
    
    private let editProfileBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit_profile_settings"), for: .normal)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 24
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy private var editProfileView:UIView = {
        let view = UIView()
        view.addSubview(editProfileBtn)
        editProfileBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(profileTitleLbl)
        profileTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.editProfileBtn.snp.bottom).offset(12)
        }
        return view
    }()
    
    
    
    
    let favoritesTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 1)
        return lbl
    }()
    
    
    private let favoritesBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "favorites_header"), for: .normal)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 24
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy private var favoritesView:UIView = {
        let view = UIView()
        view.addSubview(favoritesBtn)
        favoritesBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(favoritesTitleLbl)
        favoritesTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.favoritesBtn.snp.bottom).offset(12)
        }
        return view
    }()
    
    
    let celebrationsTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 1)
        return lbl
    }()
    
    
    private let celebrationsBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "occassions"), for: .normal)
        btn.backgroundColor = .accent
        btn.tintColor = .white
        btn.layer.cornerRadius = 24
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy private var celebrationsView:UIView = {
        let view = UIView()
        view.addSubview(celebrationsBtn)
        celebrationsBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(celebrationsTitleLbl)
        celebrationsTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.celebrationsBtn.snp.bottom).offset(12)
        }
        return view
    }()
    
    
    lazy private var quickServicesStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editProfileView, favoritesView, celebrationsView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 48
        return stack
    }()
   
    
    private let quickServicesView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    var callback:((HeaderAction) -> Void)?
    
    var user:UserDetails?{
        didSet{
            guard let user = user else {return}
            profileImg.download(imagePath: user.avatar?.imageUrl ?? "", size: CGSize(width: 81, height: 81), placeholder: UIImage(named: "avatar_details"))
            userNameLbl.text = "@\(user.username ?? "")"
            numberLbl.text = user.mobileNumber
            verifiedIcon.isHidden = user.isverified != "1"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(backgroundView)
        self.addSubview(quickServicesView)
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-79)
        }

        quickServicesView.addSubview(quickServicesStack)
        quickServicesStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70)
        }
        quickServicesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(126)
        }
        [settings, notificationsBtn ,profileImg, userNameLbl, numberLbl, verifiedIcon].forEach { self.backgroundView.addSubview($0) }
        
        settings.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(62)
        }
        
        notificationsBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(62)
        }
        
        profileImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(118)
            make.width.height.equalTo(80)
        }
        
        userNameLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImg.snp.bottom).offset(16)
        }
        
        verifiedIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.userNameLbl.snp.centerY)
            make.leading.equalTo(self.userNameLbl.snp.trailing).offset(4)
            make.width.height.equalTo(20)
        }
        
        numberLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.userNameLbl.snp.bottom).offset(7)
        }
        
        
        settings.tap {
            self.callback?(.settings)
        }
        
        notificationsBtn.tap {
            self.callback?(.notifications)
        }
        
        editProfileBtn.tap {
            self.callback?(.editProfile)
        }
        
        favoritesBtn.tap {
            self.callback?(.favorite)
        }
        
        celebrationsBtn.tap {
            self.callback?(.celebrations)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
