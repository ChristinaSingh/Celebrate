//
//  QuestionCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit


class AnswerCell:UITableViewCell {
    
    static let identifier:String = "AnswerCell"
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    var answer:Answers? {
        didSet{
            guard let answer else { return }
            self.titleLabel.text = AppLanguage.isArabic() ? answer.answerAr : answer.answerEn
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(64)
            make.bottom.equalToSuperview().inset(4)
        }
        
        self.containerView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
