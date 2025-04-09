//
//  CouponCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit

protocol CouponDelegate {
    func couponDidApply(_ coupon:String)
    func couponDidChanged(_ coupon:String)
    func couponDidRemove()
}

class CouponCell:UITableViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return view
    }()
    
    
    private let discountIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = .discount
        return icon
    }()
    
    
    let couponTF:UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.placeholder = "Enter voucher code".localized
        textfield.textColor = .black
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        textfield.textAlignment = AppLanguage.isArabic() ? .right : .left
        return textfield
    }()
    
    
    let clearBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(.clear, for: .normal)
        return btn
    }()
    
    private let loadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return loading
    }()
    
    
    var delegate:CouponDelegate?
    
    var discount:Double = 0.0
    
    var isLoading:Bool?{
        didSet{
            guard let isLoading = isLoading else{return}
            self.loadingView.isHidden = !isLoading
            if isLoading {
                self.clearBtn.isHidden = true
            }else{
                self.clearBtn.isHidden = self.couponTF.text?.isEmpty == true && discount.isZero || (isLoading && self.couponTF.text?.isEmpty == false)
            }
            self.couponTF.isUserInteractionEnabled = !isLoading
        }
    }
    
    var coupon:String?{
        didSet{
            self.couponTF.text = coupon
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
        
        [discountIcon, couponTF, clearBtn, loadingView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        discountIcon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(22)
        }
        
        clearBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(20)
        }
        
        loadingView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(20)
        }
        loadingView.isHidden = true
        couponTF.snp.makeConstraints { make in
            make.top.equalTo(self.discountIcon.snp.top)
            make.bottom.equalTo(self.discountIcon.snp.bottom)
            make.leading.equalTo(self.discountIcon.snp.trailing).offset(8)
            make.trailing.equalTo(self.clearBtn.snp.leading).offset(-8)
        }
        
        couponTF.addTarget(self, action: #selector(startEditing), for: .editingChanged)
        couponTF.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        clearBtn.isHidden = couponTF.text?.isEmpty == true
        clearBtn.tap {
            self.couponTF.text = ""
            self.clearBtn.isHidden = self.couponTF.text?.isEmpty == true
            self.couponTF.endEditing(true)
            self.delegate?.couponDidRemove()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func startEditing(_ textfield: UITextField){
        self.clearBtn.isHidden = textfield.text?.isEmpty == true
        self.delegate?.couponDidChanged(textfield.text ?? "")
    }
    
    @objc private func editingDidEnd(_ textfield: UITextField){
        self.clearBtn.isHidden = textfield.text?.isEmpty == true
        self.couponTF.endEditing(true)
        if let text = textfield.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            self.delegate?.couponDidApply(text)
        }
    }
    
}
