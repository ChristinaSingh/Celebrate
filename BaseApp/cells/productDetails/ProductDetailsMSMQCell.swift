//
//  ProductDetailsMSMQCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit

class ProductDetailsMSMQCell: ProductDetailsCell {

    var option : Config? {
        didSet{
            guard let option = option else {return}
            self.titleLbl.text = AppLanguage.isArabic() ? option.arName : option.name
            self.stepper.max = option.maxQty?.toInt() ?? 0
            self.stepper.counter = option.qty
            self.stepper.disablePlus = maxSelection || option.qty == option.maxQty?.toInt() ?? 0
            self.stepper.isHidden = option.qty == 0
            self.addBtn.isHidden = option.qty != 0
            if option.mediaID == "0"{
                self.img.snp.updateConstraints { make in
                    make.width.equalTo(0)
                    make.leading.equalToSuperview().offset(4)
                }
            }else{
                self.img.snp.updateConstraints { make in
                    make.width.equalTo(48)
                    make.leading.equalToSuperview().offset(16)
                }
            }
            self.img.download(imagePath: option.imageURL ?? "", size: CGSize(width: 50, height: 50))
            if option.rate?.isZeroPrice() == true {
                self.priceLbl.text = ""
                self.priceLbl.isHidden = true
                self.titleLbl.snp.updateConstraints { make in
                    make.top.equalTo(self.img.snp.top).offset(16)
                }
            }else{
                self.priceLbl.text = option.rate?.formatPrice()
                self.priceLbl.isHidden = false
                self.titleLbl.snp.updateConstraints { make in
                    make.top.equalTo(self.img.snp.top)
                }
            }
        }
    }
    
    
    var maxSelection:Bool = false{
        didSet{
            if maxSelection {
                self.addBtn.isEnabled = false
                self.addBtn.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
                self.addBtn.setTitleColor(UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5), for: .normal)
                self.addBtn.layer.borderWidth = 0
            }else{
                self.addBtn.isEnabled = true
                self.addBtn.backgroundColor = .white
                self.addBtn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
                self.addBtn.layer.borderWidth = 1
            }
        }
    }
    
    
    private let img:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 12
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    private let priceLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return lbl
    }()
    
    
    let addBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        btn.setTitle("ADD".localized, for: .normal)
        return btn
    }()
    
    
    let stepper:ProductOptionQuantityStepper = {
        let stepper = ProductOptionQuantityStepper()
        return stepper
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        [img , titleLbl , priceLbl , addBtn , stepper].forEach { view in
            self.containerView.addSubview(view)
        }
        
        img.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.img.snp.top)
            make.leading.equalTo(self.img.snp.trailing).offset(12)
            make.trailing.equalTo(self.stepper.snp.leading).offset(-4)
        }
        
        priceLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.img.snp.trailing).offset(12)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(4)
        }
        
        addBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(32)
            make.width.equalTo(60)
        }
        
        stepper.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(32)
            make.width.equalTo(88)
        }
        
        img.bringSubviewToFront(self.containerView)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(previewImg))
        img.addGestureRecognizer(tapGes)
    }
    
    @objc private func previewImg(){
        PreviewerViewController.show([option?.imageURL ?? ""])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func prepareForReuse() {
//        self.img.image = nil
//        self.titleLbl.text = nil
//        self.priceLbl.text = nil
//    }
    
}
