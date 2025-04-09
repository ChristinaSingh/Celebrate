//
//  OrderHistoryCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/08/2024.
//

import Foundation
import UIKit
import SnapKit


class OrderHistoryCell:UITableViewCell{
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let orderNoLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
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
    
    private let orderDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order date".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let orderDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let orderTimeTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order time".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    private let orderTimeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let viewDetailsBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("VIEW DETAILS".localized, for: .normal)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    
    private let rateMyOrderBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Rate order".localized, for: .normal)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
        return btn
    }()
    
    var delegate:OrdersDelegate?
    var order:Order?{
        didSet{
            guard let order = order else {return}
            orderNoLbl.text = "\("Order no. #".localized)\(order.id ?? "")"
            if order.orderCategory() == .completed {
                self.rateMyOrderBtn.isHidden = order.rated != nil
            }else{
                self.rateMyOrderBtn.isHidden = true
            }
            
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
            priceLbl.text = "\("kd".localized) \(order.amount ?? "")"
            orderDateLbl.text = order.creationDate
            orderTimeLbl.text = order.orderTime
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
        
        [orderNoLbl , orderStatusLbl, priceLbl , separatorIcon, orderDateTitleLbl, orderDateLbl, orderTimeTitleLbl, orderTimeLbl, viewDetailsBtn, rateMyOrderBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        orderNoLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        orderStatusLbl.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.orderNoLbl.snp.bottom).offset(8)
        }
        
        
        separatorIcon.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.priceLbl.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        orderDateTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.separatorIcon.snp.bottom).offset(12)
        }
        
        orderDateLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.orderDateTitleLbl.snp.centerY)
        }
        
        orderTimeTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.orderDateTitleLbl.snp.bottom).offset(8)
        }
        
        orderTimeLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.orderTimeTitleLbl.snp.centerY)
        }
        
        viewDetailsBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.orderTimeLbl.snp.bottom).offset(21)
            make.bottom.equalToSuperview().offset(-21)
            make.height.equalTo(22)
        }
        viewDetailsBtn.tap {
            self.delegate?.viewOrderDetails(order: self.order)
        }
        
        rateMyOrderBtn.tap {
            self.delegate?.rateOrder(order: self.order)
        }
        
        rateMyOrderBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.viewDetailsBtn.snp.centerY)
            make.width.equalTo(94)
            make.height.equalTo(32)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
