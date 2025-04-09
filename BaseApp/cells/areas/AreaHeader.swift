//
//  AreaHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/08/2024.
//

import UIKit
import SnapKit

class AreaHeader: UITableViewHeaderFooterView {

    private let titleLbl:C8Label = {
        let label = C8Label()
        label.textColor = .white
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        return label
    }()
    
    
    var area:Area?{
        didSet{
            guard let area = area else {return}
            self.titleLbl.text = AppLanguage.isArabic() ? area.arName : area.name
        }
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLbl)
        contentView.backgroundColor = .accent
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
