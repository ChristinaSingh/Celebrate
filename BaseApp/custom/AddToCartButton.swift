//
//  AddToCartButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/05/2024.
//

import UIKit
import SnapKit


class AddToCartButton: UIView {
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = .white
        lbl.text = "Add to cart".localized
        return lbl
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = .white
        return lbl
    }()
    
    private let btn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    
    var price:String?{
        didSet{
            guard let price = price else {
                self.priceLbl.text = nil
                self.titleLbl.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                }
                
                self.priceLbl.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.width.equalTo(0)
                }
                return
            }
            self.priceLbl.text = price
            self.titleLbl.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
            }
            
            self.priceLbl.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-16)
            }
        }
    }
    
    
    var requiresMoreTime:Bool?{
        didSet{
            guard let requiresMoreTime = requiresMoreTime else{return}
            self.btn.isUserInteractionEnabled = !requiresMoreTime
            if requiresMoreTime {
                self.titleLbl.text = "Requires more time to prepare".localized
                self.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
                self.price = nil
            }else{
                self.titleLbl.text = "Add to cart".localized
                self.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                self.titleLbl.textColor = .white
            }
        }
    }
    
    
    
    var locationNotAvailable:Bool?{
        didSet{
            guard let locationNotAvailable = locationNotAvailable else{return}
            self.btn.isUserInteractionEnabled = !locationNotAvailable
            if locationNotAvailable {
                self.titleLbl.text = "Not available in selected area".localized
                self.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
                self.price = nil
            }else{
                self.titleLbl.text = "Add to cart".localized
                self.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                self.titleLbl.textColor = .white
            }
        }
    }
    
    
    
    var fullybooked:Bool?{
        didSet{
            guard let fullybooked = fullybooked else{return}
            self.btn.isUserInteractionEnabled = !fullybooked
            if fullybooked {
                self.titleLbl.text = "Fully booked".localized
                self.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
                self.price = nil
            }else{
                self.titleLbl.text = "Add to cart".localized
                self.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
                self.titleLbl.textColor = .white
            }
        }
    }
    
    var isUpdated:Bool?{
        didSet {
            guard let isUpdated else{return}
            titleLbl.text = isUpdated ? "update cart".localized : "Add to cart".localized
        }
    }
    
    var tap:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLbl , priceLbl , btn].forEach { view in
            self.addSubview(view)
        }
        self.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        priceLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(0)
        }
        
        
        titleLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btn.tap {
            self.tap?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
