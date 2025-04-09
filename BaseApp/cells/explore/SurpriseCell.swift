//
//  CorprateCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 23/11/2024.
//

import Foundation
import UIKit
import SnapKit

class SurpriseCell:UITableViewCell {
    
    static let identifier:String = "SurpriseCell"
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .accent.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    
    private let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .black
        lbl.text = "Discover a special way to surprise!".localized
        lbl.numberOfLines = 0
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    private let subtitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .black.withAlphaComponent(0.5)
        lbl.numberOfLines = 0
        lbl.text = "A new and immersive way to celebrate a special occassion".localized
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    private let img: UIImageView = {
        let img = UIImageView(image: UIImage(named: "corprate_banner_img\(AppLanguage.isArabic() ? "_ar" : "")"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    let exploreBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        btn.setTitle("Explore".localized, for: .normal)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
        
        [titleLbl, subtitleLbl, img, exploreBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        
        img.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().offset(-32)
            make.width.equalTo(100)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.trailing.equalTo(self.img.snp.leading).offset(-40)
        }
        
       
        
        subtitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(self.img.snp.leading).offset(-40)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
        }
        
        exploreBtn.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.width.equalTo(76)
            make.height.equalTo(32)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showBanners(banners:Banners) {
        //in case any change required by backend
    }
    
}
