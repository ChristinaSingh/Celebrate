//
//  EditOrderActionView.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/08/2024.
//

import Foundation
import SnapKit


class EditOrderActionView: UIView {
 
    private let icon:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    private let action:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var image:UIImage?{
        didSet{
            self.icon.image = image
        }
    }
    
    
    var title:String?{	        didSet{
            self.titleLbl.text = title
        }
    }
    
    
    var isSelected:Bool?{
        didSet{
            guard let isSelected = isSelected else { return }
            if isSelected {
                self.layer.borderColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
            }else{
                self.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
            }
        }
    }
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        self.addSubview(self.icon)
        self.addSubview(self.titleLbl)
        self.addSubview(self.action)
        self.icon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        self.titleLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.icon.snp.bottom).offset(8)
        }
        
        self.action.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tap(_ action: @escaping(() -> ())){
        self.action.tap {
            action()
        }
    }
}
