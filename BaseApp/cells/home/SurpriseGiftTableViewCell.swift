//
//  SurpriseGiftTableViewCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import UIKit
import SnapKit

class SurpriseGiftTableViewCell: UITableViewCell {
    
    
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    
    
    private let surpriseView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    let surpriseImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "surprise")
        return img
    }()
    
    
    let sendGiftImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "send_gift")
        return img
    }()
    
    
    private let giftsView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    let surpriseTitle:C8Label = {
        let lbl = C8Label()
        lbl.text = "Surprise".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.numberOfLines = 2
        return lbl
    }()
    
   
    
    
    let sendGiftTitle:C8Label = {
        let lbl = C8Label()
        lbl.text = "Send Gifts".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    
    let surpriseGetStartBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    let surpriseGetStartArrow:UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.tintColor = .secondary
        return btn
    }()
    
    
    let sendGiftGetStartBtnArrow:UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.tintColor = .secondary
        return btn
    }()
    
    
    let sendGiftGetStartBtn:UIButton = {
        let btn = UIButton()
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
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        stackView.addArrangedSubview(surpriseView)
        stackView.addArrangedSubview(giftsView)
        [surpriseTitle , surpriseImg,surpriseGetStartArrow ,surpriseGetStartBtn].forEach { view in
            self.surpriseView.addSubview(view)
        }
        
        
        surpriseTitle.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(self.surpriseGetStartArrow.snp.leading).offset(-8)
        }
        

        
        surpriseImg.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }
        
        surpriseGetStartBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        surpriseGetStartArrow.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
        }
        
        [sendGiftTitle , sendGiftImg,sendGiftGetStartBtnArrow ,sendGiftGetStartBtn].forEach { view in
            self.giftsView.addSubview(view)
        }
        
        sendGiftTitle.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(self.sendGiftGetStartBtnArrow.snp.leading).offset(-8)
        }
        
        
        sendGiftImg.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }
        
        
        sendGiftGetStartBtnArrow.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
        }
        
        sendGiftGetStartBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
