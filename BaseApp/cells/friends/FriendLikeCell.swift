//
//  FriendLikeCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit

class FriendLikeCell: UICollectionViewCell {
    
    let imageContainer:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let img:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()
    
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = .center
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    let selectedIcon:UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)))
        img.tintColor = .accent
        img.backgroundColor = .white
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    var like:Product?{
        didSet {
            guard let like = like else {return}
            img.download(imagePath: like.imageURL ?? "", size: CGSize(width: 109, height: 109))
            titleLbl.text = AppLanguage.isArabic() ? like.arName : like.name
            selectedIcon.isHidden = like.isGiftFav != 1
        }
    }
    
    var hotel:VenueHotel?{
        didSet{
            guard let hotel else {return}
            img.download(imagePath: hotel.image ?? "", size: CGSize(width: 109, height: 109))
            titleLbl.text = AppLanguage.isArabic() ? hotel.nameAr : hotel.nameEn
            selectedIcon.isHidden = !hotel.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageContainer , titleLbl, selectedIcon].forEach { view in
            self.contentView.addSubview(view)
        }
        
        imageContainer.addSubview(img)
        img.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageContainer.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(frame.height - 40)
        }
        selectedIcon.isHidden = true
        selectedIcon.snp.makeConstraints { make in
            make.trailing.top.equalTo(self.img).inset(8)
            make.width.height.equalTo(16)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.imageContainer.snp.bottom).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
