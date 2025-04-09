//
//  AutoCompleteCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/09/2024.
//

import Foundation
import UIKit
import SnapKit


class AutoCompleteCell:UITableViewCell{
    
    let textLbl:UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        label.textColor = .black
        return label
    }()
        

    
    let productImg:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [textLbl, productImg].forEach { view in
            self.contentView.addSubview(view)
        }
        
        productImg.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        textLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.productImg.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
