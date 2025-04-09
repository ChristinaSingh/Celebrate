//
//  AddressTypeView.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/09/2024.
//

import Foundation
import UIKit
import SnapKit


enum AddressType:String, Codable{
    case house = "H"
    case apartment = "A"
    case office = "O"
}

class AddressTypeViewItem:UIView{
    
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return imageView
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    lazy private var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLbl])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    
    private let action:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    var title:String?{
        didSet{
            self.titleLbl.text = title
        }
    }
    
    
    var icon: UIImage?{
        didSet{
            self.imageView.image = icon
        }
    }
    
    
    var isSelected:Bool = false{
        didSet{
            self.backgroundColor = isSelected ? .accent : .white
            self.layer.borderWidth = isSelected ? 0 : 1
            self.titleLbl.textColor = isSelected ? .white : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
            self.imageView.tintColor = isSelected ? .white : UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        [stackView, action].forEach { view in
            self.addSubview(view)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        action.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tap(callback:@escaping (() -> ())){
        action.tap(callback: callback)
    }
    
}

class AddressTypeView:UIStackView{
    
    private let houseView:AddressTypeViewItem = {
        let view = AddressTypeViewItem()
        view.icon = UIImage(named: "house")
        view.title = "House".localized
        view.isSelected = false
        return view
    }()
    
    
    private let apartmentView:AddressTypeViewItem = {
        let view = AddressTypeViewItem()
        view.icon = UIImage(named: "building")
        view.title = "Apartment".localized
        view.isSelected = false
        return view
    }()
    
    
    private let officeView:AddressTypeViewItem = {
        let view = AddressTypeViewItem()
        view.icon = UIImage(named: "company")
        view.title = "Office".localized
        view.isSelected = false
        return view
    }()
    
    
    var type:AddressType? {
        didSet {
            guard let type = type else {return}
            houseView.isSelected = false
            apartmentView.isSelected = false
            officeView.isSelected = false
            switch type {
            case .house:
                houseView.isSelected = true
            case .apartment:
                apartmentView.isSelected = true
            case .office:
                officeView.isSelected = true
            }
        }
    }
    
    
    var typeDidChanged:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.distribution = .fillEqually
        self.axis = .horizontal
        self.spacing = 8
        self.addArrangedSubview(houseView)
        self.addArrangedSubview(apartmentView)
        self.addArrangedSubview(officeView)
        houseView.tap {
            self.type = .house
            self.typeDidChanged?()
        }
        
        apartmentView.tap {
            self.type = .apartment
            self.typeDidChanged?()
        }
        
        officeView.tap {
            self.type = .office
            self.typeDidChanged?()
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
