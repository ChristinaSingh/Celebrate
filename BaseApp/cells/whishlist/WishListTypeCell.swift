//
//  WishListTypeCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import UIKit
import SnapKit

class WishListTypeCell: UITableViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let icon:UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    
    private let checkmark:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "checkmark")
        return img
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    var type:WishListType?{
        didSet{
            guard let type = type else {return}
            icon.image = UIImage(named: type.icon)
            titleLbl.text = type.title
            subTitleLbl.text = type.subTitle
            checkmark.isHidden = !type.isSelected
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        
        [icon , titleLbl , subTitleLbl , checkmark].forEach { view in
            self.containerView.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.icon.snp.centerY)
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
        }
        
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLbl.snp.leading)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
        
        checkmark.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
            make.width.height.equalTo(24)
        }
        
    }

}
