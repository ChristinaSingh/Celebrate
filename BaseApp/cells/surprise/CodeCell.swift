//
//  CodeCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit


class CodeCell: UITableViewCell {
    
    static let identifier:String = "CodeCell"
    
    let otpView:OTPView = {
        let view = OTPView()
        view.color = .black
        view.isCircle = true
        view.keyboardType = .default
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(otpView)
        otpView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16)
            make.height.equalTo(56.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.otpView.clear()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
