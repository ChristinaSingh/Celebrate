//
//  EditOrderViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/08/2024.
//

import UIKit
import SnapKit


enum OrderProceedAction{
    case postpone
    case cancel
    case none
}

class EditOrderSheet: UIViewController {
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textColor = .label
        lbl.text = "Change in plans?".localized
        return lbl
    }()
    
    
    private let postponeView:EditOrderActionView = {
        let view = EditOrderActionView()
        view.image = UIImage(named: "edit_date")
        view.title = "Postpone event".localized
        return view
    }()
    
    
    private let cancelView:EditOrderActionView = {
        let view = EditOrderActionView()
        view.image = UIImage(named: "cancel")
        view.title = "Cancel event".localized
        return view
    }()
    
    
    
    private lazy var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [postponeView , cancelView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 24
        return stack
    }()
    
    
    private let proceedBtn:C8Button = {
        let btn = C8Button()
        btn.layer.cornerRadius = 24
        btn.isActive = false
        btn.setTitle("Proceed".localized)
        return btn
    }()
    
    private var action:OrderProceedAction = .none
    var callback:((OrderProceedAction) -> ())?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        [titleLbl , stackView, proceedBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
            make.height.equalTo(94)
        }
        
        proceedBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        postponeView.tap {
            self.postponeView.isSelected = true
            self.cancelView.isSelected = false
            self.proceedBtn.isActive = true
            self.action = .postpone
        }
        
        cancelView.tap {
            self.postponeView.isSelected = false
            self.cancelView.isSelected = true
            self.proceedBtn.isActive = true
            self.action = .cancel
        }
        
        
        proceedBtn.tap {
            self.dismiss(animated: true) {
                self.callback?(self.action)
            }
        }
        
    }

}

