//
//  QuestionFooterView.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit


class QuestionFooterView: UITableViewHeaderFooterView {
    
    static let identifier: String = "QuestionFooterView"
    
    let giveMeHint: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        btn.setTitleColor(.accent, for: .normal)
        btn.setTitle("Give me a hint!".localized, for: .normal)
        return btn
    }()
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(giveMeHint)
        giveMeHint.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
