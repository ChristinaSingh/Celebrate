//
//  LetsCelebrateCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class LetsCelebrateCell: UITableViewCell {
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Let’s Celebrate!".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .extrabold, size: 48)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.15)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Crafted with ♡ in Kuwait";
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.setColorForSubstring(substring: "♡", color: UIColor(red: 1, green: 0.22, blue: 0.5, alpha: 1))
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setup(){
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        [titleLbl , subTitleLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(24)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
        }
    }
    
}
