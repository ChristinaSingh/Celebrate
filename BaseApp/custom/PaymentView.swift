//
//  PaymentView.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit


enum PaymentMethod:String{
    case ApplePay = "apple_pay"
    case Knet = "knet"
    case CeditCard = "credit"
    case COD = "cash"
    
}

class PaymentView:UIView{
    
    
    private let imageView:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    var method:PaymentMethod?{
        didSet{
            guard let method = method else {return}
            self.imageView.image = UIImage(named: method.rawValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1).cgColor
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
