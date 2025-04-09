//
//  AreaCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/08/2024.
//

import Foundation
import SnapKit
import UIKit

class AreaCell:UITableViewCell{
    
    private let titleLbl:C8Label = {
        let label = C8Label()
        label.textColor = .label
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        return label
    }()
    
    
    var area:Area?{
        didSet{
            guard let area = area else{return}
            self.titleLbl.text = AppLanguage.isArabic() ? area.arName : area.name
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
