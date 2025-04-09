//
//  OptionProductDetailsHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/12/2024.
//

import Foundation
import UIKit
import SnapKit


class OptionProductDetailsHeader: UITableViewHeaderFooterView {
    
    static let identifier: String = "OptionProductDetailsHeader"
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return imageView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = AppLanguage.isArabic() ? .right : .left
        return label
    }()
    
    private let vendorNameLbl: UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    
    private let arrow:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "collapse_arrow")
        return img
    }()
    
    let actionBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var isItemExpanded:Bool? {
        didSet {
            guard let isItemExpanded = isItemExpanded else {return}
            UIView.animate(withDuration: 0.5) {
                if isItemExpanded {
                    self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }else{
                    self.arrow.transform = .identity
                }
            }
        }
    }
    
    var productDetails:ProductDetails?{
        didSet{
            guard let productDetails else { return }
            self.productImageView.download(imagePath: productDetails.imageURL ?? "", size: CGSize(width: 72, height: 72))
            self.titleLabel.text = AppLanguage.isArabic() ? productDetails.arName : productDetails.name
            self.vendorNameLbl.text = "By \(productDetails.vendor?.name ?? "")"
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(productImageView)
        self.addSubview(titleLabel)
        self.addSubview(arrow)
        self.addSubview(actionBtn)
        self.addSubview(vendorNameLbl)
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.width.height.equalTo(72)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.productImageView.snp.top).offset(12)
            make.leading.equalTo(self.productImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        vendorNameLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.productImageView.snp.trailing).offset(16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
