//
//  QuestionTitleHeaderView.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit


class QuestionTitleHeaderView: UITableViewHeaderFooterView {
    
    static let identifier: String = "QuestionTitleHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    var question: Question? {
        didSet {
            titleLabel.text = AppLanguage.isArabic() ? question?.questionAr : question?.question
            titleLabel.setLineHeight(lineHeight: 24)
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
