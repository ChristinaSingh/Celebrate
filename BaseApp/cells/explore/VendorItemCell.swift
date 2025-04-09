//
//  VendorItemCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class VendorItemCell: UICollectionViewCell {
    
    
    private let img:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()
    
    var vendor:Vendor?{
        didSet{
            guard let vendor = vendor else{return}
            img.download(imagePath: vendor.imageURL ?? "", size: CGSize(width: 100, height: 120))
        }
    }
    
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
        [img].forEach { view in
            self.contentView.addSubview(view)
        }
        
        img.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(120)
            make.center.equalToSuperview()
        }
    }
}
