//
//  BundleProductCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import Foundation
import SnapKit
import UIKit

class BundleProductCell:UICollectionViewCell {
    
    private let container:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private let image:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    var product:Product?{
        didSet{
            guard let product = product else {return}
            self.image.download(imagePath: product.imageURL ?? "", size: CGSize(width: 44, height: 44))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(container)
        self.container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.container.addSubview(image)
        self.image.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
