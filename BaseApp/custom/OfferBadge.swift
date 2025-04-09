//
//  OfferBadge.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class OfferBadge: UIView {

    private let view:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return view
    }()
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "offer")
        return icon
    }()
    
    
    private let offerLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 8)
        lbl.textColor = .white
        lbl.text = "20%\n"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    var offer:String?{
        didSet{
            self.offerLbl.text = "\(offer ?? "")%\n\("OFF".localized)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.addSubview(view)
        self.addSubview(icon)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(24)
        }
        self.view.addSubview(offerLbl)
        offerLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        icon.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.bottom)
            make.width.equalTo(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}
