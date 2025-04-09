//
//  PaymentMethodView.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import SnapKit
import UIKit


class PaymentMethodView: UIView {
    
    let container:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    let paymentView:PaymentView = {
        let view = PaymentView()
        return view
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .label
        return lbl
    }()
    
    
    let selectBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Select".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.setTitleColor(.accent, for: .normal)
        return btn
    }()
    

    let topSeparator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.container)
        self.container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [paymentView, titleLbl, selectBtn, topSeparator].forEach { view in
            self.container.addSubview(view)
        }
        
        paymentView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(16)
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(paymentView.snp.trailing).offset(12)
        }
        
        selectBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-17)
        }
        topSeparator.isHidden = true
        topSeparator.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select(callback: @escaping() -> ()){
        self.selectBtn.tap(callback: callback)
    }
    
}
