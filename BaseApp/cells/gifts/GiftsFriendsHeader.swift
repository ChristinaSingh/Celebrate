//
//  GiftsFriendsHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit


class GiftsFriendsHeader: UICollectionReusableView {
    
    static let identifier: String = "GiftsFriendsHeader"
    
    private let sendGiftView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    
    private let sendGiftIconImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sendGiftIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let sendGiftTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        label.text = "Send a gift".localized
        return label
    }()
    
    
    private let sendGiftSubTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.text = "Want to send a gift outside your friends list? No worries - We got you covered!".localized
        label.textAlignment = AppLanguage.isArabic() ? .right : .left
        label.numberOfLines = 2
        return label
    }()
    
    
    private let forwardIcon:UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: AppLanguage.isArabic() ? "chevron.left" : "chevron.right" ))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    
    let sendGiftBtn:UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let friendListHeaderLbl:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        label.text = "Send gift to a friend".localized
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.sendGiftView)
        self.addSubview(self.friendListHeaderLbl)
        
        
        sendGiftView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(96)
        }
        
        [sendGiftIconImageView, sendGiftTitleLabel, sendGiftSubTitleLabel, forwardIcon, sendGiftBtn].forEach { view in
            self.sendGiftView.addSubview(view)
        }
        
        sendGiftIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(48)
        }
        
        sendGiftTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.sendGiftIconImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(17)
        }
        
        
        forwardIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        
        
        sendGiftSubTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.sendGiftTitleLabel.snp.leading)
            make.trailing.equalTo(self.forwardIcon.snp.leading).offset(-16)
            make.top.equalTo(self.sendGiftTitleLabel.snp.bottom).offset(4)
        }
        
        sendGiftBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        friendListHeaderLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.sendGiftView.snp.bottom).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
