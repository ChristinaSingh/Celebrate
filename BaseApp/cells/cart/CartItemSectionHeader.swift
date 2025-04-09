//
//  CartItemSectionHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit

class CartItemSectionHeader: UITableViewHeaderFooterView {
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        return view
    }()
    
    
    private let dateLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        return lbl
    }()
    
    
    var editTimeButton:UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    var date:String?{
        didSet{
            dateLbl.text = date
        }
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(containerView)
        self.containerView.addSubview(dateLbl)
        self.containerView.addSubview(editTimeButton)
        containerView.layer.cornerRadius = 8
        containerView.layer.maskedCorners = [ .layerMinXMinYCorner , .layerMaxXMinYCorner ]
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        editTimeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
