//
//  ViewCartView.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/08/2024.
//

import Foundation
import UIKit
import SnapKit


class ViewCartView: UIView {
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = .white
        return lbl
    }()
    
    
    
    private let viewCartTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = .white
        lbl.text = "View Cart".localized
        return lbl
    }()
    
    private let actionBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    
    var title:String?{
        didSet{
            self.titleLbl.text = title
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .accent
        self.layer.cornerRadius = 24
        actionBtn.layer.cornerRadius = 24
        [titleLbl , viewCartTitleLbl, actionBtn].forEach { view in
            self.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        viewCartTitleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        
        
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tap(callback: @escaping() -> ()){
        self.actionBtn.tap(callback: callback)
    }
}
