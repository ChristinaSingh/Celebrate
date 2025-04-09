//
//  DineOutTableViewCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import UIKit
import SnapKit

class DineOutTableViewCell: UITableViewCell {

    private let contentBg:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        return view
    }()

    let img:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "dine_out")
        return img
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.text = "Dine out".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        return lbl
    }()
    
    
    let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "dine_out_sub_title".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    let getStartBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("GET STARTED".localized, for: .normal)
        btn.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        return btn
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(){
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(contentBg)
        contentBg.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        [img , titleLbl , subTitleLbl , getStartBtn].forEach { view in
            self.contentBg.addSubview(view)
        }
        
        img.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(self.contentView.frame.width * 0.4)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(24)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
        
        getStartBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(18)
        }
    }


}
