//
//  MyFavoritesHeaderReusableView.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/05/2024.
//

import UIKit
import SnapKit

class MyFavoritesHeaderReusableView: UICollectionReusableView {
        
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "What are you interested in?".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .black
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Let others know your favorites to help them plan an event for you".localized
        lbl.numberOfLines = 2
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLbl, subTitleLbl].forEach { view in
            self.addSubview(view)
        }

        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
