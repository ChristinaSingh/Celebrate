
//
//  PendingApprovalItemSummery.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/12/2024.
//

import Foundation
import UIKit
import SnapKit

protocol PendingApprovalItemSummeryDelegate: AnyObject {
    func didTapPayNow()
}

class PendingApprovalItemSummery: UICollectionViewCell {
    
    static let identifier:String = "PendingApprovalItemSummery"
    weak var delegate: PendingApprovalItemSummeryDelegate?
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.text = "Order summary".localized
        return lbl
    }()
    
    
    
    private let contentBg:UIView = {
        let view = UIView()
        view.backgroundColor = .clear //.white.withAlphaComponent(0.25)
        return view
    }()
    
    
    
    let statusTtitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .white
        return lbl
    }()
    
    
    let progressBar:AMProgressBar = {
        let progressBar = AMProgressBar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 64, height: 8)))
        progressBar.progressValue = 0.5
        progressBar.customize { bar in
            bar.cornerRadius = 4
            bar.borderColor = UIColor.clear
            bar.borderWidth = 0
            bar.barCornerRadius = 4
            bar.barColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
            bar.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
            bar.barMode = AMProgressBarMode.determined.rawValue
            bar.hideStripes = false
            bar.stripesColor = UIColor(red: 0, green: 0.753, blue: 0.596, alpha: 1)
            bar.stripesWidth = 10
            bar.stripesSpacing = 10
            bar.stripesMotion = AMProgressBarStripesMotion.none.rawValue
            bar.stripesOrientation = AMProgressBarStripesOrientation.diagonalRight.rawValue
            bar.textColor = UIColor.clear
        }
        return progressBar
    }()
    
    
    let orderDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order date".localized
        lbl.textColor = .white.withAlphaComponent(0.75)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    let orderDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "12 Mar, 2024"
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    let deliveryDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Delivery date".localized
        lbl.textColor = .white.withAlphaComponent(0.75)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    let deliveryDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "01 - 15 Mar, 2024"
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    // PayNow btn
    let payNowBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Pay Now".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.layer.cornerRadius = 10
        
        return btn
    }()
    
    // add tap func for PayNow btn
    @objc private func payNowBtnTapped(){
        print("PayNow btn Tapped")
        delegate?.didTapPayNow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        payNowBtn.addTarget(self, action: #selector(payNowBtnTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(){
        self.contentView.backgroundColor = .white.withAlphaComponent(0.25)
        self.contentView.layer.cornerRadius = 12
        self.backgroundColor = .clear
        [titleLbl , contentBg].forEach { view in
            self.contentView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().offset(16)
        }
        
        
        contentBg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
        
        [statusTtitleLbl , progressBar , orderDateTitleLbl , orderDateLbl , deliveryDateTitleLbl , deliveryDateLbl, payNowBtn].forEach { view in
            self.contentBg.addSubview(view)
        }
        
        
        statusTtitleLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.statusTtitleLbl.snp.bottom).offset(8)
            make.height.equalTo(8)
        }
        
        orderDateTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.progressBar.snp.bottom).offset(14)
            make.height.equalTo(18)
        }
        
        
        orderDateLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.orderDateTitleLbl.snp.bottom)
            make.height.equalTo(22)
        }
        
        
        deliveryDateTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(16)
            make.top.equalTo(self.progressBar.snp.bottom).offset(14)
            make.height.equalTo(18)
        }
        
        deliveryDateLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.deliveryDateTitleLbl.snp.leading)
            make.top.equalTo(self.deliveryDateTitleLbl.snp.bottom)
            make.height.equalTo(22)
        }
        
        // Btn goes here
        payNowBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.top.equalTo(self.progressBar.snp.bottom).offset(14)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        
        contentBg.applyHorizontalLinearGradient(colors: [UIColor.white.withAlphaComponent(0.25).cgColor , UIColor.white.withAlphaComponent(0).cgColor , UIColor.white.withAlphaComponent(0.25).cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    }
}
