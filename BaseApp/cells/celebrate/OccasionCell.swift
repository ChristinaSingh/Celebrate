//
//  OccasionCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/09/2024.
//

import Foundation
import UIKit
import SnapKit


class OccasionCell:UICollectionViewCell{
    
    
    private let container:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let image:UIImageView = {
        let img = UIImageView()
        img.tintColor = .accent
        return img
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    var occasion:CelebrateOcassion?{
        didSet{
            guard let occasion = occasion else {return}
            let fullPath = "\(occasion.imageURL ?? "")/\(occasion.mediaID ?? "")"
            self.image.download(imagePath: fullPath, size: CGSize(width: 32, height: 32))
            self.titleLbl.text = AppLanguage.isArabic() ? occasion.arName : occasion.name
            if occasion.isSelected {
                self.image.tintColor = .white
                self.titleLbl.textColor = .white
                self.container.backgroundColor = .accent
            }else{
                self.image.tintColor = .accent
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
                self.container.backgroundColor = .white
            }
        }
    }
    
    
    var eventOccasion:PlanEventOccasion?{
        didSet{
            guard let occasion = eventOccasion else {return}
            let fullPath = AppLanguage.isArabic() ? occasion.imageURLAr : occasion.imageURL
            self.image.download(imagePath: fullPath ?? "", size: CGSize(width: 32, height: 32))
            self.titleLbl.text = AppLanguage.isArabic() ? occasion.nameAr : occasion.name
            if occasion.isSelected {
                self.image.tintColor = .white
                self.titleLbl.textColor = .white
                self.container.backgroundColor = .accent
            }else{
                self.image.tintColor = .accent
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
                self.container.backgroundColor = .white
            }
        }
    }
    
    var venu:VenueType?{
        didSet{
            guard let venu = venu else {return}
            self.image.image = UIImage(named: "venue_\(venu.id ?? 0)")
            self.titleLbl.text = AppLanguage.isArabic() ? venu.nameAr : venu.name
            if venu.isSelected {
                self.image.tintColor = .white
                self.titleLbl.textColor = .white
                self.container.backgroundColor = .accent
            }else{
                self.image.tintColor = .accent
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
                self.container.backgroundColor = .white
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.contentView.addSubview(self.container)
        self.container.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        [self.image, self.titleLbl].forEach { view in
            self.container.addSubview(view)
        }
        
        self.image.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.image.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
