//
//  TimeSlotsSegmentControl.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/05/2024.
//

import Foundation
import UIKit
import SnapKit

class TimeTypeView:UIView{
    
    let icon:UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    let actionBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private let stack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    var isSelected:Bool = false{
        didSet{
            if isSelected {
                self.icon.tintColor = .white
                self.titleLbl.textColor = .white
            }else{
                self.icon.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
                self.titleLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 2
        stack.addArrangedSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
        stack.addArrangedSubview(titleLbl)
        [stack , actionBtn].forEach { view in
            self.addSubview(view)
        }
        
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TimeSlotsSegmentControl: UIView {
    
    var type:TimeSlotType = .AM {
        didSet{
            self.morningView.isSelected = type == .AM
            self.eveningView.isSelected = type == .PM
            self.selectView(view: type == .AM ? morningView : eveningView)
        }
    }
    
    
    var timeTypeChanged:((TimeSlotType) -> Void)?
    
    
    private let selectorView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return view
    }()
    
    private let stack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let morningView:TimeTypeView = {
        let view = TimeTypeView()
        view.icon.image = UIImage(named: "morning")
        view.titleLbl.text = "Morning".localized
        return view
    }()
    
    
    private let eveningView:TimeTypeView = {
        let view = TimeTypeView()
        view.icon.image = UIImage(named: "evening")
        view.titleLbl.text = "Evening".localized
        return view
    }()
    
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        self.layer.borderWidth = 1
        [selectorView , stack].forEach { view in
            self.addSubview(view)
        }
        stack.addArrangedSubview(morningView)
        stack.addArrangedSubview(eveningView)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        selectorView.snp.makeConstraints { make in
            make.edges.equalTo(self.morningView.snp.edges)
        }
        
        eveningView.actionBtn.tap {
            self.timeTypeChanged?(.PM)
        }
        
        morningView.actionBtn.tap {
            self.timeTypeChanged?(.AM)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func selectView(view:TimeTypeView){
        self.selectorView.snp.remakeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
}
