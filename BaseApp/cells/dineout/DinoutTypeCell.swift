//
//  DinoutTypeCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/11/2024.
//

import Foundation
import UIKit
import SnapKit


class DinoutTypeCell: UITableViewCell {
    
    static let identifier: String = "DinoutTypeCell"
    
    lazy private var containerView:UIView = {
        let view = createCardView()
        return view
    }()
    
    
    let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .black
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    private let dineoutImg:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        return img
    }()
    
    
    let descriptionLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    private let exploreBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Explore".localized, for: .normal)
        btn.setTitleColor(.accent, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    
    private let exploreArrowBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        btn.tintColor = .accent
        return btn
    }()
    
    
    var category:PopUPSCategory? {
        didSet {
            guard let type = category else{return}
            self.dineoutImg.image = getImage(type: type.imageType ?? "")
            self.titleLbl.text = AppLanguage.isArabic() ? type.arName : type.name
            self.descriptionLbl.text = AppLanguage.isArabic() ? type.descAr : type.desc
        }
    }
    
    var tap:(() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        [dineoutImg, titleLbl, descriptionLbl, exploreBtn, exploreArrowBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        
        dineoutImg.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
            make.width.equalTo((UIApplication.shared.screen.width - 32) * 0.5)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.trailing.equalTo(self.dineoutImg.snp.leading).offset(-8)
        }
        
        descriptionLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.dineoutImg.snp.leading).offset(-8)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(4)
        }
        
        exploreBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
        
        exploreArrowBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.exploreBtn.snp.centerY)
            make.leading.equalTo(self.exploreBtn.snp.trailing).offset(4)
        }
        exploreBtn.tap {self.tap?() }
        exploreArrowBtn.tap {self.tap?() }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createCardView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.screen.width - 32, height: 220)
        let shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 12)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 12
        layer0.shadowOffset = CGSize(width: 0, height: 12)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        let shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)

        shapes.layer.cornerRadius = 12

        return view
        
    }
    
    
    func getImage(type:String) -> UIImage? {
        if type.lowercased() == "restaurants".lowercased() {
            return UIImage(named: "restaurants")
        }else if type.lowercased() == "parks".lowercased(){
            return UIImage(named: "park")
        }else if type.lowercased() == "beaches".lowercased(){
            return UIImage(named: "beach")
        }else if type.lowercased() == "rooftops".lowercased(){
            return UIImage(named: "rooftops")
        }else if type.lowercased() == "elsewhere".lowercased(){
            return UIImage(named: "else_where")
        }
        return UIImage(named: "park")
    }
    
}
