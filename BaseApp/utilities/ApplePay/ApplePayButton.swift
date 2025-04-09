//
//  ApplePayButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/08/2024.
//

import Foundation
import UIKit
import SnapKit


class ApplePayButton:UIView {
    
    private let applePayIcon:UIImageView = {
        let applePayIcon = UIImageView()
        applePayIcon.image = .applePay.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        applePayIcon.tintColor = .white
        applePayIcon.contentMode = .scaleAspectFit
        return applePayIcon
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return lbl
    }()
    
    
    lazy private var stack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLbl , applePayIcon])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    
    private let action:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    var title:String?{
        didSet{
            self.titleLbl.text = title
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        [stack, action].forEach { view in
            self.addSubview(view)
        }
        
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        action.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        applePayIcon.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tap(callback: @escaping (() -> ())){
        self.action.tap(callback: callback)
    }
    
}
