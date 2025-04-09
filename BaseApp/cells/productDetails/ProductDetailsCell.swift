//
//  ProductDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/06/2024.
//

import UIKit
import SnapKit

class ProductDetailsCell: UITableViewCell {
    var isLastCell:Bool = false {
        didSet {
            if isLastCell {
                containerView.layer.cornerRadius = 8
                containerView.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner ]
            }else{
                containerView.layer.cornerRadius = 0
            }
        }
    }
    
    
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
