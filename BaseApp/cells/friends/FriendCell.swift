//
//  FriendCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit

class FriendCell: UITableViewCell {

    
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
    
    let acceptBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "accept_friend_request"), for: .normal)
        return btn
    }()
    
    
    let rejectBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "reject_friend_request"), for: .normal)
        return btn
    }() 
    
    
    let addBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add"), for: .normal)
        return btn
    }()
    
    
    private let requestSentBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("REQUEST SENT".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 10)
        btn.setTitleColor(UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5), for: .normal)
        btn.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    
    private lazy var acceptRejectActions:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [acceptBtn , rejectBtn])
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.axis = .horizontal
        return stack
    }()
    
    
    private lazy var addSentActions:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addBtn , requestSentBtn])
        return stack
    }()
    
    
    
    private let loadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return loading
    }()
    
    
    var friend:Friend?{
        didSet{
            guard let friend = friend else {return}
            friendLbl.text = "@\(friend.customer?.username ?? "")"
            birthDayLbl.text = "\("Birthday:".localized)\(friend.customer?.formateDate() ?? "")"
            avatarImg.download(imagePath: friend.customer?.avatar?.imageURL ?? "", size: CGSize(width: 64, height: 64))
            if friend.loading {
                acceptRejectActions.isHidden = true
                addSentActions.isHidden = true
                accessoryType = .none
                loadingView.isHidden = false
            }else{
                loadingView.isHidden = true
                if let invStatus = friend.invStatus {
                    accessoryType = invStatus == "1" ? .disclosureIndicator : .none
                    acceptRejectActions.isHidden = invStatus == "1"
                    addSentActions.isHidden = true
                }else if let invitestatus = friend.invitestatus {
                    acceptRejectActions.isHidden = true
                    accessoryType = .none
                    switch invitestatus {
                    case 0:
                        requestSentBtn.isHidden = true
                        addBtn.isHidden = false
                        addSentActions.isHidden = false
                        break
                    case 1:
                        requestSentBtn.isHidden = false
                        addBtn.isHidden = true
                        addSentActions.isHidden = false
                        break
                    case 2:
                        addSentActions.isHidden = true
                        accessoryType = .disclosureIndicator
                        break
                    default:
                        requestSentBtn.isHidden = true
                        addBtn.isHidden = false
                        addSentActions.isHidden = false
                    }
                }else{
                    accessoryType = .none
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        [avatarImg , friendLbl, birthDayLbl , acceptRejectActions , addSentActions , loadingView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        avatarImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.width.height.equalTo(64)
        }
        
        friendLbl.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImg.snp.top).offset(8)
            make.leading.equalTo(self.avatarImg.snp.trailing).offset(16)
        }
        
        birthDayLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImg.snp.trailing).offset(16)
            make.top.equalTo(self.friendLbl.snp.bottom).offset(8)
        }
        
        acceptRejectActions.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        
        addSentActions.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        } 
        
        loadingView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(16)
        }
        
        requestSentBtn.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(104)
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
