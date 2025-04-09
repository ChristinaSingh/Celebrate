//
//  SurpriseCardCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/11/2024.
//

import Foundation
import UIKit
import SnapKit


class SurpriseCardCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "SurpriseCardCell"
    
    private let cardView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    
    private let icon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    
    
    private let titleLbl:UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        return label
    }()
    
    
    private let subtitleLbl:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    
    var onBoarding:SurpriseOnBoarding?{
        didSet {
            guard let onBoarding = onBoarding else { return }
            icon.image = onBoarding.icon
            titleLbl.text = onBoarding.title
            subtitleLbl.text = onBoarding.description
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(cardView)
        self.cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [icon, titleLbl, subtitleLbl].forEach { view in
            self.cardView.addSubview(view)
        }
        
        subtitleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.subtitleLbl.snp.top).offset(-24)
        }
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.titleLbl.snp.top).offset(-24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
