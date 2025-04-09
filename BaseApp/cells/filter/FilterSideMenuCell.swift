//
//  FilterSideMenuCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/06/2024.
//

import UIKit
import SnapKit

class FilterSideMenuCell: UITableViewCell {

    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        return lbl
    }()
    
    
    

    var menuItem:FilterSideMenu?{
        didSet{
            guard let menuItem = menuItem else {return}
            titleLbl.text = menuItem.title
            titleLbl.textColor = menuItem.isSelected ? UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1) : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
            titleLbl.font = menuItem.isSelected ? AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14) : AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLbl].forEach { view in
            self.contentView.addSubview(view)
        }
    
        
        titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
