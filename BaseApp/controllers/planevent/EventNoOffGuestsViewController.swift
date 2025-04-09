//
//  EventNoOffGuestsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/09/2024.
//

import Foundation
import UIKit
import SnapKit


class EventNoOffGuestsViewController: PlanEventUserNameViewController{
    
    override init(service: Service, body: PlanEventBody) {
        super.init(service: service, body: body)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let hintLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "A minimum of 10 people is required to proceed".localized
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLbl.text = "Expected no. of guests".localized
        titleLbl.text = "Organize event".localized
        input.keyboardType = .asciiCapableNumberPad
        input.placeholder = "0".localized
        
        self.view.addSubview(hintLbl)
        
        hintLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.input.snp.bottom).offset(48)
        }
        
        proceedBtn.tap = {
            self.body.noOfGuests = self.input.text
            let vc = VenuTypeViewController(service: self.service, body: self.body)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        proceedBtn.enableDisableSaveButton(isEnable: !newText.isEmpty)
        return true
    }
}
