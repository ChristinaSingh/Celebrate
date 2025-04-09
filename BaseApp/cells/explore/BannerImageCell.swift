//
//  BannerImageCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//

import UIKit
import SnapKit

class BannerImageCell: UICollectionViewCell {
    
    
    let image:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 12
        return img
    }()
    
    
    var imageUrl:String?{
        didSet{
            guard let url = imageUrl else {return}
            let encodedStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
            image.download(imagePath: encodedStr, size: CGSize(width: UIScreen.main.bounds.width - 32, height: 360))
        }
    }
    
    var border:CGFloat?{
        didSet{
            guard let border = border else {return}
            image.layer.borderWidth = border
            image.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
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
        self.contentView.addSubview(self.image)
        self.image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        image.image = nil
    }
}
