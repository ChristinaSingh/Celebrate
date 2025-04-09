//
//  LifeLineView.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit


class LifrLineView: UIView {
    
    private let titleLbl:UILabel = {
       let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textAlignment = .center
        lbl.text = "LIFE LINES".localized
        return lbl
    }()
    
    let fiftyBtn:C8IconButton = {
        let btn = C8IconButton(frame: .zero)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 24
        btn.icon = UIImage(named: "fifty")
        btn.title = "50/50"
        btn.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.titleColor = .white
        btn.padding = -8
        btn.isCentered = true
        btn.iconSize = CGSize(width: 32, height: 32)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    
    
    let vastaBtn:C8IconButton = {
        let btn = C8IconButton(frame: .zero)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 24
        btn.icon = UIImage(named: "vasta")
        btn.title = "WASTA"
        btn.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.titleColor = .white
        btn.iconSize = CGSize(width: 32, height: 32)
        btn.padding = -3
        btn.isCentered = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    lazy private var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fiftyBtn, vastaBtn])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var isFiftyActive:Bool = true {
        didSet {
            if isFiftyActive {
                fiftyBtn.isUserInteractionEnabled = true
                fiftyBtn.titleColor = .white
                fiftyBtn.layer.borderColor = UIColor.white.cgColor
            }else{
                fiftyBtn.isUserInteractionEnabled = false
                fiftyBtn.titleColor = .white.withAlphaComponent(0.25)
                fiftyBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
            }
        }
    }
    
    
    var isVastaActive:Bool = true {
        didSet {
            if isVastaActive {
                vastaBtn.isUserInteractionEnabled = true
                vastaBtn.titleColor = .white
                vastaBtn.layer.borderColor = UIColor.white.cgColor
            }else{
                vastaBtn.isUserInteractionEnabled = false
                vastaBtn.titleColor = .white.withAlphaComponent(0.25)
                vastaBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        [titleLbl, stackView].forEach { view in
            self.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(24)
            make.height.equalTo(48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
