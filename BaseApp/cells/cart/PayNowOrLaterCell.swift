//
//  PayNowOrLaterCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 31/08/2024.
//

import Foundation
import UIKit
import SnapKit

class PayNowOrLaterCell: UITableViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    
    private let icon:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        lbl.textColor = .black
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var payNowOrLater:PayNowOrLater?{
        didSet{
            guard let payNowOrLater = payNowOrLater else {return}
            icon.image = payNowOrLater.img
            titleLbl.text = payNowOrLater.title
            subTitleLbl.text = payNowOrLater.subTitle
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        [icon, titleLbl, subTitleLbl].forEach { view in
            self.containerView.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(24)
            make.width.height.equalTo(80)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.icon.snp.bottom).offset(24)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(24)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
