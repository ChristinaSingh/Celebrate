//
//  SettingsHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit

class SettingsHeader: UITableViewHeaderFooterView {

    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        return lbl
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        self.backgroundColor = .white
        [titleLbl].forEach { view in
            self.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(1)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}
