//
//  OrderLocationCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation
import UIKit
import SnapKit

class OrderLocationCell:UITableViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let icon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "address")
        return imageView
    }()
    
    
    private let addressNameLbl:C8Label = {
        let label = C8Label()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        label.textColor = .label
        return label
    }()
    
    
    private let addressLbl:C8Label = {
        let label = C8Label()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    
    private let mobileNumLbl:C8Label = {
        let label = C8Label()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = .gray
        return label
    }()
    
    
    var order:Order?{
        didSet{
            guard let order = self.order else {return}
            self.addressNameLbl.text = order.address?.name
            self.addressLbl.text = "\(order.address?.area ?? ""), Block-\(order.address?.block ?? ""), Street-\(order.address?.street ?? ""), House-\(order.address?.building ?? "") "
            self.mobileNumLbl.text = "Mobile: \(order.address?.altNum ?? "")"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        [icon, addressNameLbl, addressLbl, mobileNumLbl].forEach { view in
            self.containerView.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        addressNameLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.icon.snp.centerY)
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
        }
        
        addressLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.addressNameLbl.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.addressNameLbl.snp.bottom).offset(9)
        }
        
        mobileNumLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.addressNameLbl.snp.leading)
            make.top.equalTo(self.addressLbl.snp.bottom).offset(9)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
