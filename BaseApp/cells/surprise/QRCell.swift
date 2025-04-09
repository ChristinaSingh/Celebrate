//
//  QRCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit


class QRCell: UITableViewCell {
    
    static let identifier: String = "QRCell"
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Tap here to open the QR scanner".localized
        label.textAlignment = .center
        return label
    }()
    
    
    private let qrImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "qrCode")
        return imageView
    }()
    
    private let qrCodeImageContainer:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy private var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [qrCodeImageContainer,titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(300.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.bottom.equalToSuperview().inset(4)
        }
        
        self.containerView.addSubview(stackView)
        self.stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        qrCodeImageContainer.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        qrCodeImageContainer.addSubview(qrImageView)
        qrImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
