//
//  ContactsUsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class ContactsUsCell: UITableViewCell {
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.text = "Tell us what you are looking for!".localized
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.text = "Your feedback will help us improve recommendations for you".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    let tellUsBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.setTitle("Tell us".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    
    private let timeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.text = "Take 30 seconds or less".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "tell_us")
        icon.backgroundColor = .clear
        return icon
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        [titleLbl , subTitleLbl , tellUsBtn , icon , timeLbl].forEach { view in
            self.containerView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
        
        tellUsBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(12)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
        
        timeLbl.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(self.tellUsBtn.snp.bottom).offset(8)
        }
        
        icon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-26)
            make.width.equalTo(129.constraintMultiplierTargetValue.relativeToIphone8Width())
        }
    }
}
