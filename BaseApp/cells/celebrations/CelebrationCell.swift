//
//  CelebrationCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import Foundation
import UIKit
import SnapKit

class CelebrationCell:UITableViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "birthday")// will be changed based on apis
        return icon
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.text = "Mohammed’s Birthday"
        return lbl
    }()
    
    let addressLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 2
        lbl.text = "Home sweet home"
        return lbl
    }()
    
    let dateLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.text = "2 months & 12 days to go"
        return lbl
    }()
    
    
    let viewBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("VIEW".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    
    let inviteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Plan Event".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    
    lazy var actions:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [viewBtn , inviteBtn])
        stack.axis = .horizontal
        stack.spacing = 32
        return stack
    }()
    
    private let dateView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    
    private let monthDayLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 10)
        lbl.text = "10 JUN"
        return lbl
    }()
    
    private let halfCircle:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "half_circle")
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        [icon, titleLbl, addressLbl, dateLbl, actions].forEach { view in
            self.containerView.addSubview(view)
        }
        icon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.icon.snp.centerY)
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        addressLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLbl.snp.leading)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(9)
        }
        
        dateLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.addressLbl.snp.leading)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(self.addressLbl.snp.bottom).offset(12)
        }
        
        
        actions.snp.makeConstraints { make in
            make.leading.equalTo(self.dateLbl.snp.leading)
            make.top.equalTo(self.dateLbl.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self.contentView.addSubview(dateView)
        self.contentView.addSubview(halfCircle)
        dateView.snp.makeConstraints { make in
            make.top.equalTo(self.containerView.snp.top).offset(17)
            make.trailing.equalTo(self.containerView.snp.trailing).offset(4)
            make.height.equalTo(22)
            make.width.equalTo(51)
        }
        
        halfCircle.snp.makeConstraints { make in
            make.top.equalTo(self.dateView.snp.bottom)
            make.trailing.equalTo(self.dateView.snp.trailing)
            make.width.height.equalTo(4)
        }
        self.dateView.addSubview(monthDayLbl)
        monthDayLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    
    }
    
}
