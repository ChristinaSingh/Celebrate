//
//  IntroView.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/03/2024.
//

import Foundation
import UIKit
import SnapKit

class IntroView:UIView {
    
    private let cartIcon:UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    private lazy var cartView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 0.1).cgColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    private let cartTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .label
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.numberOfLines = 2
        lbl.alpha = 0.5
        return lbl
    }()
    

    
    init(title: String, subTitle: String, icon: UIImage?) {
        cartTitleLbl.text = title
        subTitleLbl.text = subTitle
        cartIcon.image = icon
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        [cartView , cartTitleLbl , subTitleLbl].forEach { view in
            self.addSubview(view)
        }
        
        cartView.snp.makeConstraints { make in
            make.width.height.equalTo(75.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.leading.centerY.equalToSuperview()
        }
        
        cartView.addSubview(cartIcon)
        cartIcon.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(24.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        cartTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.cartView.snp.top)
            make.leading.equalTo(self.cartView.snp.trailing).offset(16)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.cartView.snp.trailing).offset(16)
            make.top.equalTo(self.cartTitleLbl.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
        }
    }
    
}
