//
//  ProductSliderCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 26/04/2024.
//

import UIKit
import SnapKit

class ProductSliderCell: UICollectionViewCell {
    
    private let img:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        return img
    }()
    
    
    var imgURL:String?{
        didSet{
            guard let imgURL = imgURL else{return}
            img.download(imagePath: imgURL, size: CGSize(width: 200, height: 200))
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
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        img.image = nil
    }
}
