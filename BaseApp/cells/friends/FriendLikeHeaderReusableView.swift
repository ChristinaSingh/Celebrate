//
//  FriendLikeHeaderReusableView.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit

class FriendLikeHeaderReusableView: UICollectionReusableView {
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .black
        lbl.text = "Favorites".localized
        return lbl
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
