//
//  OrderPaymentDetailsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation
import UIKit
import SnapKit


class OrderPaymentDetailsCell: UITableViewCell {
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let paymentDetailsTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.text = "Payment details".localized
        return lbl
    }()
    
    
    private let orderStatusLbl:PaddedLabel = {
        let lbl = PaddedLabel()
        lbl.textInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 10)
        lbl.textColor = .white
        lbl.layer.cornerRadius = 4
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return lbl
    }()
    
    
    private let separatorIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "separator")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let totalTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Total amount".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let totalLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let deliveryFeesTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Delivery fee".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let deliveryFeesLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let paymentMethodTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Payment method".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let paymentMethodLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let trackIDTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Track ID".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let trackIDLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let viewReceiptBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("VIEW RECEIPT".localized, for: .normal)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    
    var order:Order?{
        didSet {
            guard let order = order else {return}
            self.priceLbl.text = "\("kd".localized) \(order.amount ?? "")"
            switch order.orderCategory() {
            case .paid:
                self.orderStatusLbl.text = "PAID"
                self.orderStatusLbl.backgroundColor = UIColor(red: 0, green: 0.753, blue: 0.596, alpha: 1)
            case .confirmed:
                self.orderStatusLbl.text = "CONFIRMED"
                self.orderStatusLbl.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
            case .completed:
                self.orderStatusLbl.text = "COMPLETED"
                self.orderStatusLbl.backgroundColor = UIColor(red: 0, green: 0.753, blue: 0.596, alpha: 1)
            case .cancelled:
                self.orderStatusLbl.backgroundColor = .systemRed
                self.orderStatusLbl.text = "CANCELLED"
            case .refunded:
                self.orderStatusLbl.backgroundColor = UIColor(red: 0, green: 0.753, blue: 0.596, alpha: 1)
                self.orderStatusLbl.text = "REFUNDED"
            case .all:
                self.orderStatusLbl.text = ""
                self.orderStatusLbl.backgroundColor = .clear
            default:
                break
            }
            self.totalLbl.text = "\("kd".localized) \(order.amount ?? "")"
            self.deliveryFeesLbl.text = "\("kd".localized) \(order.deliveryFee ?? "")"
            self.paymentMethodLbl.text = order.paymentMode
            self.trackIDLbl.text = order.trackid
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
        
        [paymentDetailsTitleLbl , orderStatusLbl, priceLbl , separatorIcon, totalTitleLbl, totalLbl, deliveryFeesTitleLbl, deliveryFeesLbl,paymentMethodTitleLbl,  paymentMethodLbl, trackIDTitleLbl, trackIDLbl, viewReceiptBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        paymentDetailsTitleLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        orderStatusLbl.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.paymentDetailsTitleLbl.snp.bottom).offset(8)
        }
        
        
        separatorIcon.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.priceLbl.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        totalTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.separatorIcon.snp.bottom).offset(12)
        }
        
        totalLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.totalTitleLbl.snp.centerY)
        }
        
        deliveryFeesTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.totalTitleLbl.snp.bottom).offset(8)
        }
        
        deliveryFeesLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.deliveryFeesTitleLbl.snp.centerY)
        }
        
        paymentMethodTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.deliveryFeesTitleLbl.snp.bottom).offset(8)
        }
        
        paymentMethodLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.paymentMethodTitleLbl.snp.centerY)
        }
        
        
        trackIDTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.paymentMethodTitleLbl.snp.bottom).offset(8)
        }
        
        trackIDLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.trackIDTitleLbl.snp.centerY)
        }
        
        viewReceiptBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.trackIDTitleLbl.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(0)
            make.height.equalTo(16)
        }
        viewReceiptBtn.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
