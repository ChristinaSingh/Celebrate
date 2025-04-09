//
//  PaymentMethodViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import SnapKit
import UIKit


class PaymentMethodViewController:UIViewController {
    
    
    private let isCreditCard:Bool
    init(isCreditCard: Bool) {
        self.isCreditCard = isCreditCard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Choose payment method".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .black
        lbl.text = "Payment methods".localized
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .black
        lbl.text = "Please select your payment method down below.".localized
        return lbl
    }()
    
    
    private let applePayView:PaymentMethodView = {
        let view = PaymentMethodView()
        view.paymentView.method = .ApplePay
        view.titleLbl.text =  "Apple pay".localized
        return view
    }()
    
    private let creditView:PaymentMethodView = {
        let view = PaymentMethodView()
        view.paymentView.method = .CeditCard
        view.titleLbl.text =  "Credit Card (Visa / Master Card)".localized
        view.container.backgroundColor = .clear
        view.container.layer.cornerRadius = 0
        view.container.layer.borderWidth = 0
        return view
    }()
    
    
    lazy private var knetView:PaymentMethodView = {
        let view = PaymentMethodView()
        view.paymentView.method = .Knet
        view.titleLbl.text =  "KNET".localized
        view.container.backgroundColor = .clear
        view.container.layer.cornerRadius = 0
        view.container.layer.borderWidth = 0
        return view
    }()
    
    
    lazy private var codView:PaymentMethodView = {
        let view = PaymentMethodView()
        view.paymentView.method = .COD
        view.container.backgroundColor = .clear
        view.container.layer.cornerRadius = 0
        view.container.layer.borderWidth = 0
        view.titleLbl.text =  "Cash on delivery".localized
        return view
    }()
    
    
    private let orPayWithTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "OR PAY WITH".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 10)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    private let leftSeparator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()

    private let rightSeparator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let methodsStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 8
        stack.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        stack.layer.borderWidth = 1
        return stack
    }()
    
    
    var callback:((PaymentMethod?, String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView, titleLbl, subTitleLbl, applePayView, leftSeparator, orPayWithTitleLbl, rightSeparator, methodsStack].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
        }
        
        applePayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(16)
            make.height.equalTo(56)
        }
        
        orPayWithTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.applePayView.snp.bottom).offset(32)
        }
        
        leftSeparator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(self.orPayWithTitleLbl.snp.centerY)
            make.height.equalTo(1)
            make.trailing.equalTo(self.orPayWithTitleLbl.snp.leading).offset(-16)
        }
        
        rightSeparator.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.orPayWithTitleLbl.snp.centerY)
            make.height.equalTo(1)
            make.leading.equalTo(self.orPayWithTitleLbl.snp.trailing).offset(16)
        }
        
        methodsStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.orPayWithTitleLbl.snp.bottom).offset(32)
        }
        if isCreditCard {
            methodsStack.addArrangedSubview(creditView)
        }
        methodsStack.addArrangedSubview(knetView)
        //methodsStack.addArrangedSubview(codView)
        knetView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        knetView.topSeparator.isHidden = !isCreditCard
        codView.topSeparator.isHidden = false
        knetView.select {
            self.dismiss(animated: true) {
                self.callback?(self.knetView.paymentView.method, self.knetView.titleLbl.text)
            }
        }
        
        applePayView.select {
            self.dismiss(animated: true) {
                self.callback?(self.applePayView.paymentView.method, self.applePayView.titleLbl.text)
            }
        }
        
        creditView.select {
            self.dismiss(animated: true) {
                self.callback?(self.creditView.paymentView.method, self.creditView.titleLbl.text)
            }
        }
        
        codView.select {
            self.dismiss(animated: true) {
                self.callback?(self.codView.paymentView.method, self.codView.titleLbl.text)
            }
        }
        
    }

}
