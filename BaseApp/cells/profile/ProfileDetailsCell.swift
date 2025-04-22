//
//  ProfileDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/05/2024.
//

import Foundation
import SnapKit

class ProfileDetailsCell: UICollectionViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    
    private let profileImg:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 40.5
        img.clipsToBounds = true
        img.image = UIImage(named: "avatar_details")
        return img
    }()
    
    
    let userNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        return lbl
    }()
    
    
//    private let flagLbl:C8Label = {
//        let lbl = C8Label()
//        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
//        lbl.text = "🇰🇼"
//        return lbl
//    }()
    
    
    let numberLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        return lbl
    }()
    
    
    
    private let verifiedIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "verified")
        return img
    }()
    
    
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
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [profileImg , userNameLbl , numberLbl , verifiedIcon].forEach { view in
            self.containerView.addSubview(view)
        }
        
        
        profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(81)
            make.leading.top.equalToSuperview().inset(24)
        }
        
        userNameLbl.snp.makeConstraints { make in
            make.top.equalTo(self.profileImg.snp.top).offset(12)
            make.leading.equalTo(self.profileImg.snp.trailing).offset(16)
        }
        
        verifiedIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.userNameLbl.snp.centerY)
            make.leading.equalTo(self.userNameLbl.snp.trailing).offset(4)
        }
        
        
        numberLbl.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLbl.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
