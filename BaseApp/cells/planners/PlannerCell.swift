//
//  PlannerCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/09/2024.
//

import UIKit
import SnapKit

class PlannerCell: UITableViewCell {

    private let avatarImg:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 32
        img.layer.masksToBounds = true
        return img
    }()
    
    
    private let plannerName:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
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
    
    
    var planner:Planner? {
        didSet{
            guard let planner = planner else {return}
            self.avatarImg.download(imagePath: planner.iconURL ?? "", size: CGSize(width: 64, height: 64))
            self.plannerName.text = AppLanguage.isArabic() ? planner.nameAr : planner.name
            self.rateLbl.text = planner.rating
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator
        
        [avatarImg, plannerName, rateIcon, rateLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        avatarImg.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(16)
        }
        
        plannerName.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImg.snp.top).offset(8)
            make.leading.equalTo(self.avatarImg.snp.trailing).offset(16)
            make.height.equalTo(22)
        }
        
        rateIcon.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImg.snp.trailing).offset(16)
            make.top.equalTo(self.plannerName.snp.bottom).offset(8)
            make.width.height.equalTo(16)
        }
        
        rateLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.rateIcon.snp.centerY)
            make.leading.equalTo(self.rateIcon.snp.trailing).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
