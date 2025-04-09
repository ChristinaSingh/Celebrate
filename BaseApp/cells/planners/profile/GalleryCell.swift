//
//  GalleryCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 16/09/2024.
//

import UIKit
import SnapKit

class GalleryCell: UICollectionViewCell {
    
    private let image:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 4
        return image
    }()
    
    var gallery:Gallery? {
        didSet {
            guard let gallery = gallery else {return}
            image.download(imagePath: gallery.imageURL ?? "", size: self.frame.size, placeholder: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
