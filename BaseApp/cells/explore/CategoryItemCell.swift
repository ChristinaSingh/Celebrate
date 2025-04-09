//
//  CategoryItemCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 25/04/2024.
//

import UIKit
import SnapKit

class CategoryItemCell: UICollectionViewCell {
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 40
        icon.clipsToBounds = true
        icon.layer.borderColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
        return icon
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    var category:Category? {
        didSet{
            guard let category = category else {return}
            titleLbl.text = AppLanguage.isArabic() ? category.arName : category.name
            icon.download(imagePath: category.imageURL ?? "", size: CGSize(width: 80, height: 80))
            categoryBar.isHidden = !category.isSelected
            icon.layer.borderWidth = category.isSelected ? 1 : 0
        }
    }
    
    
    var iconSize:CGFloat?{
        didSet {
            guard let size = iconSize else {return}
            icon.layer.cornerRadius = size / 2
            self.icon.snp.updateConstraints { make in
                make.width.height.equalTo(size)
            }
        }
    }
    
    
    private let categoryBar:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "selected_bar")
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        [icon , titleLbl, categoryBar].forEach { view in
            self.contentView.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.centerX.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(12)
        }
        
        categoryBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    
    override func prepareForReuse() {
        icon.image = nil
        titleLbl.text = nil
    }
    
}
