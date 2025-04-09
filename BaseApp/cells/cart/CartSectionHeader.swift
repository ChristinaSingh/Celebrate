//
//  CartSectionHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit

class CartSectionHeader: UITableViewHeaderFooterView{
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    var title:String?{
        didSet{
            self.titleLbl.text = title
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
