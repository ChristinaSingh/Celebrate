//
//  OnBoardingCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/11/2024.
//

import Foundation
import UIKit
import SnapKit

class OnBoardingCell: UICollectionViewCell {
    
    static let identifier: String = "OnBoardingCell"
    
    
    private let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        lbl.textAlignment = .center
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var intro:Intro?{
        didSet {
            guard let intro = intro else { return }
            imageView.image = intro.image
            titleLbl.text = intro.title
            imageView.snp.remakeConstraints { make in
                make.width.equalTo(intro.size.width)
                make.height.equalTo(intro.size.height)
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                make.top.equalTo(self.titleLbl.snp.bottom)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        [titleLbl, imageView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview()
            make.height.equalTo(90)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(70)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
