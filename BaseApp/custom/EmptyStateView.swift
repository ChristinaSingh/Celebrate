//
//  EmptyStateView.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit

class EmptyStateView: UIView {
    let imgSize:CGSize
    var message:String {
        didSet {
            self.messageLbl.text = message
        }
    }
    var icon:UIImage?{
        didSet{
            self.img.image = icon
        }
    }
    init(icon: UIImage?, message: String, imgSize:CGSize) {
        self.imgSize = imgSize
        self.message = message
        self.icon = icon
        super.init(frame: .zero)
        self.setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let img:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    private func setup(){
        self.backgroundColor = .clear
        [img , messageLbl].forEach { view in
            self.addSubview(view)
        }
        img.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(self.imgSize.width)
            make.height.equalTo(self.imgSize.height)
        }
        
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.img.snp.bottom).offset(16)
        }
    }
    
}
