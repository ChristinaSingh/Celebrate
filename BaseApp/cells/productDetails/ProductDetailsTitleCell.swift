//
//  ProductDetailsTitleCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit

class ProductDetailsTitleCell: UITableViewCell {
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        return lbl
    }()
    
    
    private let payUpApprovalLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(red: 1, green: 0.518, blue: 0.333, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 10)
        lbl.text = "Pay upon approval".localized.uppercased()
        lbl.layer.cornerRadius = 10
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    var title:String?{
        didSet{
            self.titleLbl.text = title
        }
    }
    
    var price:String?{
        didSet{
            if let priceDouble = Double(price ?? "0.0"), priceDouble <= 0.0 {
                pricePerSelectionView.isHidden = false
                priceLbl.isHidden = true
                payUpApprovalLbl.snp.remakeConstraints { make in
                    make.width.equalTo(140)
                    make.height.equalTo(20)
                    make.centerY.equalTo(self.pricePerSelectionView.snp.centerY)
                    make.leading.equalTo(self.pricePerSelectionView.snp.trailing).offset(8)
                }
            }else{
                pricePerSelectionView.isHidden = true
                priceLbl.isHidden = false
                payUpApprovalLbl.snp.remakeConstraints { make in
                    make.width.equalTo(140)
                    make.height.equalTo(20)
                    make.centerY.equalTo(self.priceLbl.snp.centerY)
                    make.leading.equalTo(self.priceLbl.snp.trailing).offset(8)
                }
            }
            self.priceLbl.text = price?.formatPrice()
        }
    }
    
    lazy private var pricePerSelectionView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.layer.cornerRadius = 12
        view.addSubview(pricePerSelectionLbl)
        pricePerSelectionLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    private let pricePerSelectionLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 8)
        lbl.textColor = .white
        lbl.text = "Price per selection".localized
        return lbl
    }()
    
    
    var isPayUpOnApproval:Bool?{
        didSet{
            payUpApprovalLbl.isHidden = isPayUpOnApproval == false
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        [titleLbl , priceLbl, pricePerSelectionView , payUpApprovalLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
        }
        
        priceLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLbl.snp.leading)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
        }
        
        pricePerSelectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLbl.snp.leading)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(24)
        }
        
        payUpApprovalLbl.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(20)
            make.centerY.equalTo(self.priceLbl.snp.centerY)
            make.leading.equalTo(self.priceLbl.snp.trailing).offset(8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func prepareForReuse() {
//        self.titleLbl.text = nil
//        self.priceLbl.text = nil
//    }
}
