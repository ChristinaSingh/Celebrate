//
//  OrderItemCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/09/2024.
//

import Foundation
import UIKit
import SnapKit

class OrderItemCell:UITableViewCell{
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .label
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 2
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return lbl
    }()
    
    
    private let dotView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        view.layer.cornerRadius = 2
        return view
    }()
    
    let vendorNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textColor = .label
        lbl.textAlignment = AppLanguage.isArabic() ? .left : .right
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    private let seperator:UIImageView = {
        let img = UIImageView()
        img.image = .separator
        return img
    }()
    
    var order: Order?{
        didSet{
            guard let order else { return }
            titleLbl.text = order.product?.name
            vendorNameLbl.text = "By \(order.vendor?.name ?? "")"
            priceLbl.text = "\(order.amount ?? "") \("KD".localized)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [dotView, titleLbl, priceLbl, vendorNameLbl, seperator].forEach { view in
            self.containerView.addSubview(view)
        }
        
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(4)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(25)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.dotView.snp.centerY)
        }
        

        titleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.dotView.snp.trailing).offset(16)
            make.centerY.equalTo(self.dotView.snp.centerY)
            make.trailing.equalTo(self.priceLbl.snp.leading)
        }
        
        vendorNameLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLbl.snp.leading)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
        }
        
        seperator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
