//
//  NoFriendsFoundCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit


class NoFriendsFoundCell: UICollectionViewCell {
    
    static let identifier: String = "NoFriendsFoundCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let noFriendsImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "no_friends_found")
        return img
    }()
    
    
    private let noFriendsLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textAlignment = .center
        lbl.text = "Look’s like you’ve not added friends to your list".localized
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    let inviteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Invite friends".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    
    private let contentViewObj:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerView.addSubview(contentViewObj)
        self.contentViewObj.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(228)
        }
        self.contentViewObj.addSubview(noFriendsImg)
        self.contentViewObj.addSubview(noFriendsLbl)
        self.contentViewObj.addSubview(inviteBtn)
        
        self.noFriendsImg.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        noFriendsLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.noFriendsImg.snp.bottom).offset(16)
        }
        
        inviteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.noFriendsLbl.snp.bottom).offset(16)
            make.width.equalTo(106)
            make.height.equalTo(32)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
