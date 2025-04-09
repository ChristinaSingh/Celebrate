//
//  HeaderViewWithCancelButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import Foundation
import UIKit
import SnapKit

protocol HeaderViewWithCancelButtonDelegate: AnyObject {
    func headerViewWithCancelButtonDidTapCancel()
}

class HeaderViewWithCancelButton: UIView {
    
    weak var delegate: HeaderViewWithCancelButtonDelegate?
    
    
    let title:String
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
        titleLbl.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        btn.setTitleColor(UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1), for: .normal)
        return btn
    }()
    
    @objc private func cancelTapped() {
        print("Cancel Button Tapped")
        delegate?.headerViewWithCancelButtonDidTapCancel()
    }
    
    
    let resetBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Reset".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    
    private let separator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    
    var withResetBtn:Bool = false {
        didSet{
            if withResetBtn {
                resetBtn.isHidden = false
                resetBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    
    var resetDidTapped:(() -> Void)?
    
    private func setup(){
       
        [cancelBtn , titleLbl, resetBtn, separator].forEach { view in
            self.addSubview(view)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-11)
        }
        resetBtn.isHidden = true
        resetBtn.isUserInteractionEnabled = false
        resetBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.cancelBtn.snp.centerY)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        resetBtn.tap {
            self.resetDidTapped?()
        }
    }
    
    func cancel(vc:UIViewController){
        self.cancelBtn.tap {
            vc.dismiss(animated: true)
        }
    }
    
}
