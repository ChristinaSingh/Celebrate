//
//  AddressCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit

class AddressCell: UITableViewCell {
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "address")
        return icon
    }()
    
    
    
    private let addressNamleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    
    let addressLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    let mobileLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    let editBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("EDIT".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    
    let deleteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("DELETE".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    
    lazy var actions:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editBtn , deleteBtn])
        stack.axis = .horizontal
        stack.spacing = 32
        return stack
    }()
    
    private let loadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return loading
    }()
    
    var address:Address?{
        didSet{
            guard let address = address else {return}
            loadingView.isHidden = !address.loading
            actions.isHidden = address.loading
            addressNamleLbl.text = address.name
            addressLbl.text = "\(address.area ?? ""),\("Block".localized)-\(address.block ?? ""),\("Street".localized)-\(address.street ?? ""),\("House".localized) \(address.building ?? "")"
            mobileLbl.text = "\("Mobile:".localized) \(address.alternateNumber ?? "")"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        [icon, addressNamleLbl, addressLbl, mobileLbl, actions, loadingView].forEach { view in
            self.containerView.addSubview(view)
        }
        icon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        addressNamleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.icon.snp.centerY)
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        addressLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.addressNamleLbl.snp.leading)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(self.addressNamleLbl.snp.bottom).offset(9)
        }
        
        mobileLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.addressLbl.snp.leading)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(self.addressLbl.snp.bottom).offset(12)
        }
        
        
        actions.snp.makeConstraints { make in
            make.leading.equalTo(self.mobileLbl.snp.leading)
            make.top.equalTo(self.mobileLbl.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        loadingView.snp.makeConstraints { make in
            make.leading.equalTo(self.mobileLbl.snp.leading)
            make.top.equalTo(self.mobileLbl.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(16)
        }
        
    }
}
