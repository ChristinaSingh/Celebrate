//
//  C8IconButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//

import UIKit
import SnapKit

class C8IconButton: UIView {
    
    private let image:UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    private let actionBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var icon:UIImage?{
        didSet{
            image.image = icon
        }
    }
    
    
    var iconSize:CGSize?{
        didSet{
            guard let iconSize = iconSize else {return}
            self.image.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(12.constraintMultiplierTargetValue.relativeToIphone8Width())
                make.width.equalTo(iconSize.width)
                make.height.equalTo(iconSize.height)
            }
        }
    }
    
    
    var title:String?{
        didSet{
            titleLbl.text = title
            titleLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        }
    }
    
    var iconColor:UIColor = .white {
        didSet{
            image.setImageColor(color: iconColor)
        }
    }
    
    
    var titleColor:UIColor = .white {
        didSet {
            titleLbl.textColor = titleColor
        }
    }
    
    var font:UIFont? = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14) {
        didSet{
            self.titleLbl.font = font
        }
    }
    
    var padding:CGFloat = 0
    
    
    var isCentered:Bool = false{
        didSet{
            if isCentered {
                self.centeredViews()
            }else{
                setup()
            }
        }
    }
    
    var tap:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        [image , titleLbl , actionBtn].forEach { view in
            self.addSubview(view)
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12.constraintMultiplierTargetValue.relativeToIphone8Width())
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.image.snp.trailing).offset(12.constraintMultiplierTargetValue.relativeToIphone8Width())
            make.trailing.equalToSuperview().offset(-8.constraintMultiplierTargetValue.relativeToIphone8Width())
        }
        
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        actionBtn.tap {
            self.tap?()
        }
    }
    
    
    func centeredViews() {
        [image , titleLbl , actionBtn].forEach { view in
            view.removeFromSuperview()
        }
        let stack = UIStackView(arrangedSubviews: [image , titleLbl])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalCentering
        [stack, actionBtn].forEach { view in
            self.addSubview(view)
        }
        
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(self.padding) // -8 because of spaces in the icon itself
        }
        
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        actionBtn.tap {
            self.tap?()
        }
    }
    
}
