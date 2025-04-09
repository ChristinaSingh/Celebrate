//
//  GameLifeLineView.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/11/2024.
//

import Foundation
import UIKit
import SnapKit


class GameLifeLineView: UIView {
    
    private let lifesImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "lifes")
        return img
    }()
    
    private let lifesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return label
    }()
    
    
    lazy private var lifesstackView: UIView = {
        let stackView = UIView()
        [lifesImageView, lifesLabel].forEach { view in
            stackView.addSubview(view)
        }
        return stackView
    }()
    
    var lifes: Int?{
        didSet {
            guard let lifes else { return }
            self.lifesLabel.text = "\(lifes)"
        }
    }
    
    
    private let skipsImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "skips")
        return img
    }()
    
    private let skipsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return label
    }()
    
    
    lazy private var skipsStackView: UIView = {
        let stackView = UIView()
        [skipsImageView, skipsLabel].forEach { view in
            stackView.addSubview(view)
        }
        return stackView
    }()
    
    var skips: Int?{
        didSet {
            guard let skips else { return }
            self.skipsLabel.text = "\(skips)"
        }
    }
    
    
    private let completedImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "completed")
        return img
    }()
    
    private let completedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return label
    }()
    
    
    lazy private var completedStackView: UIView = {
        let stackView = UIView()
        [completedImageView, completedLabel].forEach { view in
            stackView.addSubview(view)
        }
        return stackView
    }()
    
    var completed: String?{
        didSet {
            guard let completed else { return }
            self.completedLabel.text = "\(completed)"
        }
    }
    
    
    private let lifesSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        return view
    }()
    
    private let skipsSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        return view
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        [lifesstackView, lifesSeparator, skipsStackView, skipsSeparator, completedStackView].forEach { view in
            self.addSubview(view)
        }
        
        lifesstackView.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
        }
        
        lifesSeparator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.leading.equalTo(self.lifesstackView.snp.trailing)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        skipsStackView.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.leading.equalTo(self.lifesSeparator.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        skipsSeparator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.leading.equalTo(self.skipsStackView.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        completedStackView.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.leading.equalTo(self.skipsSeparator.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        lifesImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        lifesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.lifesImageView.snp.trailing).offset(4)
        }
        
        skipsImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        skipsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.skipsImageView.snp.trailing).offset(4)
        }
        
        
        completedImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.completedImageView.snp.trailing).offset(4)
        }

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

