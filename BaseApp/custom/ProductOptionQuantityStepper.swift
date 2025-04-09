//
//  ProductOptionQuantityButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/05/2024.
//

import Foundation
import UIKit
import SnapKit

class ProductOptionQuantityStepper: UIView {

    
    private let plusBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return btn
    }()
    
    private let minusBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "minus.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
        return btn
    }()
    
    private let countLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        lbl.text = "1"
        return lbl
    }()
    
    var disableMinus:Bool = false {
        didSet{
            if disableMinus {
                self.minusBtn.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
                self.minusBtn.isEnabled = false
            }else{
                self.minusBtn.isEnabled = true
                self.minusBtn.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
            }
        }
    }
    
    var disablePlus:Bool = false {
        didSet{
            if disablePlus {
                self.plusBtn.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.25)
                self.plusBtn.isEnabled = false
            }else{
                self.plusBtn.isEnabled = true
                self.plusBtn.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
            }
        }
    }
    
    
    var counter:Int = 0{
        didSet{
            self.countLbl.text = String(format: "%02d", counter)
            self.disableMinus = counter == 0
            self.disablePlus = counter == max
        }
    }
    
    
    var valueChanged:((Int) -> Void)?
    
    var min:Int = 0
    var max:Int = 3
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
        [minusBtn , countLbl , plusBtn].forEach { view in
            self.addSubview(view)
        }
        
        minusBtn.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        countLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        plusBtn.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
        }
        
        plusBtn.tap {
            if self.counter < self.max {
                self.counter += 1
                self.valueChanged?(self.counter)
            }
        }
        
        minusBtn.tap {
            if self.counter > self.min {
                self.counter -= 1
                self.valueChanged?(self.counter)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
