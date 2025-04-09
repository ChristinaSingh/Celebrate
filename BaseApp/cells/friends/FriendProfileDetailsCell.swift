//
//  FriendProfileDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit

class FriendProfileDetailsCell: UICollectionViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    private let avatarImg:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 32
        img.clipsToBounds = true
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return img
    }()
    
    
    private let friendLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    private let birthDayLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.alpha = 0.5
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        return lbl
    }()
    

    
    let reminderView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 16
        return view
    }()
    
    
    let reminderIcon:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "alarm"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    
    let reminderTitle:UIButton = {
        let btn = UIButton()
        btn.setTitle("Remind Me".localized, for: .normal)
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return btn
    }()
    
    let reminderBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let loadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = .accent
        return loading
    }()
    
    
    let reminderLoadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = .accent
        return loading
    }()
    
    let removeBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle(("Remove friend".localized), for: .normal)
        btn.setTitleColor(UIColor(red: 1, green: 0.22, blue: 0.5, alpha: 1), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return btn
    }()
    
    
    var friend:Friend?{
        didSet{
            guard let friend = friend else {return}
            friendLbl.text = friend.customer?.fullname
            birthDayLbl.text = "\("Birthday:".localized)\(friend.customer?.formateDate() ?? "")"
            avatarImg.download(imagePath: friend.customer?.avatar?.imageURL ?? "", size: CGSize(width: 64, height: 64))
            updateRemindView(friend: friend)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [avatarImg , friendLbl, birthDayLbl , reminderView, reminderLoadingView, loadingView, removeBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        avatarImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(64)
        }
        
        friendLbl.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImg.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        birthDayLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.friendLbl.snp.bottom).offset(8)
        }
        
        [reminderIcon , reminderTitle , reminderBtn].forEach { view in
            self.reminderView.addSubview(view)
        }
        
        reminderIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        
        reminderTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.reminderIcon.snp.trailing).offset(8)
        }
        
        reminderBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        reminderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.birthDayLbl.snp.bottom).offset(23)
            make.width.equalTo(180)
            make.height.equalTo(32)
        }
        reminderLoadingView.isHidden = true
        reminderLoadingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.birthDayLbl.snp.bottom).offset(23)
            make.width.height.equalTo(24)
        }
        
        loadingView.isHidden = true
        loadingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.reminderView.snp.bottom).offset(16)
            make.width.height.equalTo(24)
        }
        
        removeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.reminderView.snp.bottom).offset(16)
        }
        
    }
    
    func updateRemindView(friend: Friend) {
        if friend.remindme == 1 {
            self.reminderView.backgroundColor = .lightGray
            self.reminderTitle.setTitleColor(.black, for: .normal)
            self.reminderIcon.tintColor = .black
            self.reminderTitle.setTitle("Reminder applied".localized, for: .normal)
        }else{
            self.reminderView.backgroundColor = .accent
            self.reminderTitle.setTitleColor(.white, for: .normal)
            self.reminderIcon.tintColor = .white
            self.reminderTitle.setTitle("Remind Me".localized, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        self.friendLbl.text = nil
        self.birthDayLbl.text = nil
        self.avatarImg.image = nil
    }
}
