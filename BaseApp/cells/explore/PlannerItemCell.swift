//
//  PlannerItemCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class PlannerItemCell: UICollectionViewCell {
    
    private let img:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    
    var planner:Planner?{
        didSet{
            guard let planner = planner else{return}
            img.download(imagePath: planner.iconURL ?? "", size: CGSize(width: 64, height: 64))
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
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.center.equalToSuperview()
        }
    }
}
