//
//  CartItemCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit

enum CartContextAction{
    case edit
    case delete
}

class CartItemCell: UITableViewCell {
    
    private let minusButton = UIButton()
    private let plusButton = UIButton()
    private let quantityLabel = UILabel()
    
    private var quantity = 1 {
        didSet {
            quantityLabel.text = "\(quantity)"
        }
    }
    
    private let statusLabel = UILabel() // "Waiting for approval" label


    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLbl:C8Label = {
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
    
    
    private let vendorNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label.withAlphaComponent(0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    private let deliveryTimeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    
    private let deliveryFeesTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Delivery fee".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .label
        return lbl
    }()

    
    private let deliveryFeesLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        lbl.textColor = .label
        return lbl
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textColor = .label
        lbl.textAlignment = AppLanguage.isArabic() ? .left : .right
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    
    private let payUpApprovalLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(red: 1, green: 0.518, blue: 0.333, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 10)
        lbl.text = "Pay upon approval".localized.uppercased()
        lbl.layer.cornerRadius = 10
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    lazy var moreBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "more"), for: .normal)
        btn.showsMenuAsPrimaryAction = true
        return btn
    }()
    
    
    private let seperator:UIImageView = {
        let img = UIImageView()
        img.image = .separator
        return img
    }()
    
    
    let loadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return loading
    }()
    
    var cartTime:String?
    
    var cartItem:CartItem?{
        didSet{
            guard let cartItem = cartItem else {return}
            titleLbl.text = AppLanguage.isArabic() ? cartItem.product?.arName : cartItem.product?.name
            vendorNameLbl.text = "By \(cartItem.vendor?.name ?? "")"
            deliveryTimeLbl.text = cartTime != nil ? cartTime : "\(cartItem.resourceSlot?.startTime.formatTime()?.hours ?? "") - \(cartItem.resourceSlot?.endTime.formatTime()?.hours ?? "") \(cartItem.resourceSlot?.endTime.formatTime()?.amPm ?? "")"
            if cartItem.pendingItemStatus == .pending {
                payUpApprovalLbl.isHidden = false
                payUpApprovalLbl.text = "Pay upon approval".localized
                payUpApprovalLbl.textColor = .white
                payUpApprovalLbl.backgroundColor = UIColor(red: 1, green: 0.518, blue: 0.333, alpha: 1)
            }else if cartItem.pendingItemStatus == .approved_by_client {
                payUpApprovalLbl.isHidden = false
                payUpApprovalLbl.text = "Waiting for approval".localized
                payUpApprovalLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
                payUpApprovalLbl.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
            }else{
                payUpApprovalLbl.isHidden = true
            }
            
            if let amount = cartItem.actualAmount {
                priceLbl.text =  "\(amount) \("kd".localized)"
            }else{
                priceLbl.text = ""
            }
        }
    }
    
   
    
    var fee:Double?{
        didSet{
            guard let fee = fee else {return}
            deliveryFeesLbl.text = "\(fee.clean) \("kd".localized) "
        }
    }
    
    var isLastCell:Bool = false {
        didSet {
            self.seperator.isHidden = isLastCell
            if isLastCell {
                containerView.layer.cornerRadius = 8
                containerView.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner ]
            }else{
                containerView.layer.cornerRadius = 0
            }
        }
    }
    
    @objc private func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    @objc private func increaseQuantity() {
        quantity += 1
    }

    var contextActionDidTapped:((CartContextAction) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [dotView, titleLbl, priceLbl, vendorNameLbl, deliveryTimeLbl, deliveryFeesTitleLbl, deliveryFeesLbl, payUpApprovalLbl, seperator, moreBtn, loadingView,minusButton, quantityLabel, plusButton].forEach { view in
            self.containerView.addSubview(view)
        }
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        minusButton.layer.cornerRadius = 12
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = UIColor.init(named: "AccentColor")?.cgColor
        minusButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        
        // Setup quantity label
        quantityLabel.text = "\(quantity)"
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textAlignment = .center
        quantityLabel.textColor = .black
        
        // Setup plus button
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        plusButton.layer.cornerRadius = 12
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.init(named: "AccentColor")?.cgColor
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(payUpApprovalLbl.snp.bottom).offset(4)
            make.leading.equalTo(payUpApprovalLbl.snp.leading).inset(53)
            make.width.height.equalTo(25)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minusButton)
            make.leading.equalTo(minusButton.snp.trailing).offset(8)
            make.width.equalTo(23)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(minusButton)
            make.leading.equalTo(quantityLabel.snp.trailing).offset(8)
            make.width.height.equalTo(25)
        }


        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(4)
            make.leading.top.equalToSuperview().inset(16)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.dotView.snp.centerY)
        }
        
        payUpApprovalLbl.snp.makeConstraints { make in
            make.trailing.equalTo(self.priceLbl.snp.trailing)
            make.top.equalTo(self.priceLbl.snp.bottom).offset(12)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.dotView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(self.priceLbl.snp.leading)
        }
        
        vendorNameLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.titleLbl.snp.leading)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
        }
        
        
        deliveryTimeLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.vendorNameLbl.snp.leading)
            make.top.equalTo(self.vendorNameLbl.snp.bottom).offset(12)
        }
        
        deliveryFeesTitleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.deliveryTimeLbl.snp.leading)
            make.top.equalTo(self.deliveryTimeLbl.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        deliveryFeesLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.deliveryFeesTitleLbl.snp.centerY)
            make.leading.equalTo(self.deliveryFeesTitleLbl.snp.trailing).offset(3)
        }
        
        moreBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.deliveryFeesTitleLbl.snp.centerY)
        }
        loadingView.isHidden = true
        loadingView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.deliveryFeesTitleLbl.snp.centerY)
            make.width.height.equalTo(24)
        }
        
        seperator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        self.moreBtn.tap {
            self.showCustomMenu(sourceView: self.moreBtn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    var controller: UIViewController!
    
    func showCustomMenu(sourceView: UIView) {
        let popover = UIViewController()
        let menuItems: [(String, UIImage?, () -> Void)] = [

            ("EDIT".localized.capitalized, UIImage(named: "edit"), {
                popover.dismiss(animated: true)
                self.contextActionDidTapped?(.edit)
            }),
            
            ("DELETE".localized.capitalized, UIImage(named: "trash"), {
                popover.dismiss(animated: true)
                self.contextActionDidTapped?(.delete)
            }),
        ]
        
        let customMenu = CustomMenuView(menuItems: menuItems)
        customMenu.layer.cornerRadius = 8
        customMenu.clipsToBounds = true
        customMenu.backgroundColor = .white
        customMenu.frame = CGRect(x: 0, y: 0, width: 120, height: CGFloat(menuItems.count * 44))
        
       
        popover.view = customMenu
        popover.modalPresentationStyle = .popover
        popover.preferredContentSize = customMenu.frame.size
        
        if let popoverController = popover.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = CGRect(
                x: sourceView.bounds.midX,
                y: sourceView.bounds.midY,
                width: 1, height: 1
            )
            
            popoverController.permittedArrowDirections = [.up , .down ]
            popoverController.delegate = self
        }

        // Check for iPhones and fallback to a different presentation style
        if UIDevice.current.userInterfaceIdiom == .phone {
            popover.modalPresentationStyle = .overCurrentContext
            popover.view.backgroundColor = UIColor.black.withAlphaComponent(0.3) // Dim background effect
        }

        controller.present(popover, animated: true)
    }
}

extension CartItemCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Prevents fullscreen presentation on iPhones
        return .none
    }
}


