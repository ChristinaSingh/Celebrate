//
//  VendorItemTVCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit
import SnapKit

class VendorItemTVCell: UITableViewCell {

    private let img:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = .black
        return lbl
    }()

    
    private let rateIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "rate_icon")
        return icon
    }()
    
    
    private let rateLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = .black
        return lbl
    }()
    
    
    private let descLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    var vendor:Vendor?{
        didSet{
            guard let vendor = vendor else {return}
            img.download(imagePath: vendor.imageURL ?? "", size: CGSize(width: 100, height: 80))
            if AppLanguage.isArabic() {
                titleLbl.text = vendor.nameAr
            }else{
                titleLbl.text = vendor.name
            }
            rateLbl.text = vendor.rated?.rating
            descLbl.text = AppLanguage.isArabic() ? vendor.vendorArDescription : vendor.vendorDescription
            descLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        }
    }
    
    var restaurant:Restaurant?{
        didSet{
            guard let restaurant = restaurant else {return}
            img.image = UIImage(named: restaurant.imageURL ?? "")
           // img.download(imagePath: restaurant.imageURL ?? "", size: CGSize(width: 100, height: 80))
            if AppLanguage.isArabic() {
                titleLbl.text = restaurant.nameAr
            }else{
                titleLbl.text = restaurant.name
            }
            rateLbl.text = restaurant.rating
            descLbl.text = restaurant.vendorDescription
        }
    }
    
    
    var branch:RestaurantBranch?{
        didSet{
            guard let branch = branch else {return}
            img.image = UIImage(named: branch.imageURL ?? "")
           // img.download(imagePath: restaurant.imageURL ?? "", size: CGSize(width: 100, height: 80))
            if AppLanguage.isArabic() {
                titleLbl.text = branch.nameAr
            }else{
                titleLbl.text = branch.name
            }
            rateLbl.text = branch.rating
            descLbl.text = branch.description
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        [img , titleLbl , rateIcon , rateLbl , descLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        img.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(116)
            make.width.equalTo(80)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.img.snp.top).offset(13)
            make.leading.equalTo(self.img.snp.trailing).offset(16)
        }
        
        rateIcon.snp.makeConstraints { make in
            make.leading.equalTo(self.img.snp.trailing).offset(16)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(13)
            make.width.height.equalTo(16)
        }
        
        rateLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.rateIcon.snp.centerY)
            make.leading.equalTo(self.rateIcon.snp.trailing).offset(8)
        }
        
        descLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.img.snp.trailing).offset(16)
            make.top.equalTo(self.rateIcon.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func prepareForReuse() {
        img.image = nil
        titleLbl.text = nil
        descLbl.text = nil
        rateLbl.text = nil
    }
}
