//
//  ProductDetailsSectionHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 04/05/2024.
//

import UIKit
import SnapKit


class ProductDetailsSectionHeader: UITableViewHeaderFooterView {
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        //lbl.numberOfLines = 2
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    private let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    private let arrow:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "collapse_arrow")
        return img
    }()
    
    
    lazy private var titlesStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLbl, subTitleLbl])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let actionBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    
    lazy private var requiredView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.layer.cornerRadius = 12
        view.addSubview(requiredLbl)
        requiredLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    private let requiredLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .white
        lbl.text = "Required".localized
        return lbl
    }()
    
    
    var title:String?{
        didSet{
            self.titleLbl.text = title
            self.titleLbl.setColorForSubstring(substring: "*", color: .red)
            self.subTitleLbl.isHidden = true
        }
    }
    
    
    var subTitle:String?{
        didSet{
            guard let subTitle = subTitle else{
                subTitleLbl.isHidden = true
                return
            }
            subTitleLbl.isHidden = false
            self.subTitleLbl.text = subTitle
        }
    }
    
    
    var isExpanded:Bool? {
        didSet {
            guard let isExpanded = isExpanded else {return}
            UIView.animate(withDuration: 0.5) {
                if isExpanded {
                    self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self.expandedCorners()
                }else{
                    self.arrow.transform = .identity
                    self.collapsedCorners()
                }
            }
        }
    }
    
    var isRequired:Bool?{
        didSet {
            guard let isRequired else {return}
            self.requiredView.isHidden = !isRequired
            requiredView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(self.arrow.snp.leading).offset(-16)
                make.width.equalTo(isRequired ? 67 :0)
                make.height.equalTo(24)
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup(){
        self.backgroundColor = .white
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(1)
        }
        [titlesStack , arrow, requiredView , actionBtn].forEach { view in
            containerView.addSubview(view)
        }
        
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        requiredView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.arrow.snp.leading).offset(-16)
            make.width.equalTo(0)
            make.height.equalTo(24)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.requiredView.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-16)
        }
            
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func expandedCorners(){
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
    }
    
    
    private func collapsedCorners(){
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
    }
    
    func bottomCorners(){
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
    }
}
