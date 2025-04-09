//
//  PaymentSuccessViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 04/09/2024.
//

import Foundation
import UIKit
import SnapKit


class PaymentSuccessViewController:UIViewController {
    
    
    let orderId:String
    let orderDate:String
    let deliveryDate:String
    let total:String
    let isPendingApproval:Bool
    init(orderId: String, orderDate: String, deliveryDate: String, total: String, isPendingApproval: Bool = false) {
        self.orderId = orderId
        self.orderDate = orderDate
        self.deliveryDate = deliveryDate
        self.total = total
        self.isPendingApproval = isPendingApproval
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Order confirmed".localized)
        view.backgroundColor = .white
        view.cancelBtn.isHidden = true
        return view
    }()
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    private let balloons:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ["balloons1" , "balloons2", "balloons3", "balloons4"].randomElement() ?? "balloons1")
        return imageView
    }()
    
    
    private let backgroundImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success_bg")
        return imageView
    }()
    
    
   lazy private var titleLbl:C8Label = {
        let lbl = C8Label()
       lbl.text = isPendingApproval ? "Request submitted successfully".localized :  "Payment Successful".localized
        lbl.textColor = .accent
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Thank you for ordering with Celebrate!".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.text = "Please wait for the company’s confirmation sms or call.".localized
        return lbl
    }()
    
    
    private let totalTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Total amount".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    private let totalLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .accent
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        return lbl
    }()
    
    
    private let separatorImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "separator")
        return img
    }()
    
    
    private let orderIdTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order ID".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    private let orderIdLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    
    private let orderDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Order date".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    private let orderDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    private let deliveryDateTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Delivery date".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    private let deliveryDateLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    private let okCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    private lazy var okBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Okay".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView, contentView, balloons, okCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(58)
        }
        
        balloons.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(160)
            make.top.equalTo(self.headerView.snp.bottom).offset(48)
        }
        
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.headerView.snp.bottom).offset(128)
            make.height.equalTo(448)
        }
        
        okCardView.addSubview(okBtn)
        okBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        okCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(101)
            make.bottom.equalToSuperview()
        }
        
        [backgroundImage, titleLbl, subTitleLbl, messageLbl, totalTitleLbl, totalLbl, separatorImg, orderIdTitleLbl, orderIdLbl, orderDateTitleLbl, orderDateLbl, deliveryDateTitleLbl, deliveryDateLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(96)
            make.height.equalTo(24)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
            make.height.equalTo(18)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(12)
            make.height.equalTo(36)
        }
        
        totalTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageLbl.snp.bottom).offset(16)
            make.height.equalTo(18)
        }
        
        totalLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.totalTitleLbl.snp.bottom).offset(8)
            make.height.equalTo(24)
        }
        
        separatorImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(1)
            make.top.equalTo(self.totalLbl.snp.bottom).offset(24)
        }
        
        orderIdTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.separatorImg.snp.bottom).offset(24)
        }
        
        orderIdLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.orderIdTitleLbl.snp.bottom).offset(8)
        }
        
        orderDateTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.orderIdLbl.snp.bottom).offset(16)
        }
        
        orderDateLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.orderDateTitleLbl.snp.bottom).offset(8)
        }
        
        deliveryDateTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-16)
            make.top.equalTo(self.orderIdLbl.snp.bottom).offset(16)
        }
        
        deliveryDateLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-16)
            make.top.equalTo(self.deliveryDateTitleLbl.snp.bottom).offset(8)
        }
        
        self.totalLbl.text = total
        self.orderIdLbl.text = orderId
        self.orderDateLbl.text = orderDate
        self.deliveryDateLbl.text = deliveryDate
        
        okBtn.tap = {
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate {
                let vc = AppTabsViewController()
                sceneDelegate.changeRootViewController(vc)
            }
        }
        
    }
    
}
