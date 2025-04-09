//
//  GiftsFriendsCll.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit


class GiftsFriendsCell: UICollectionViewCell {
    static let identifier: String = "GiftsFriendsCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let friendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    
    private let friendNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        label.textAlignment = .center
        return label
    }()
    
    var friend:Friend? {
        didSet {
            guard let friend else { return }
            self.friendImageView.download(imagePath: friend.customer?.avatar?.imageURL ?? "", size: CGSize(width: 64, height: 64))
            self.friendNameLabel.text = friend.customer?.fullname
            self.birthdayLabel.text = "\("Birthday:".localized)\(friend.customer?.formateDate() ?? "")"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [friendImageView, friendNameLabel, birthdayLabel].forEach { view in
            self.containerView.addSubview(view)
        }
        
        self.friendImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
            make.top.equalToSuperview().offset(16)
        }
        
        friendNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.friendImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        birthdayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.friendNameLabel.snp.bottom).offset(8)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
