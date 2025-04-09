//
//  PaymentMethodCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit


class PaymentMethodCell:UITableViewCell {
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    private let paymentView:PaymentView = {
        let view = PaymentView()
        view.method = .ApplePay
        return view
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .label
        lbl.text = "Apple Pay".localized
        return lbl
    }()
    
    
    let changeBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Change".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.setTitleColor(.accent, for: .normal)
        return btn
    }()
    
    
    var method:PaymentMethod?{
        didSet{
            guard let method = method else {return}
            self.paymentView.method = method
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [paymentView, titleLbl, changeBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        paymentView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(16)
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.paymentView.snp.trailing).offset(12)
        }
        
        changeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
