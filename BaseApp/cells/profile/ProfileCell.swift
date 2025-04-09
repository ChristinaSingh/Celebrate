//
//  ProfileCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/05/2024.
//

import UIKit
import SnapKit

class ProfileCell: UICollectionViewCell {
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    private let icon:UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        lbl.textColor = .black
        return lbl
    }()
    
    private var pulse :PulseAnimation?
    
    private let notificationView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(red: 0.961, green: 0, blue: 0.722, alpha: 1)
        return view
    }()
    
    
    
    var setting:SettingModel?{
        didSet {
            guard let setting = setting else {return}
            titleLbl.text = setting.title
            icon.image = setting.icon
            notificationView.isHidden = !setting.notify
            pulse?.removeAllAnimations()
            pulse?.isAnimating = true
            pulse?.applicationWillEnterForeground()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [icon , titleLbl   , notificationView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(16)
        }
        
        notificationView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(8)
        }
        
        pulse = PulseAnimation(numberOfPulse: .infinity, radius: 12, postion: CGPoint(x: notificationView.frame.origin.x + 4, y: notificationView.frame.origin.y + 4))
        pulse?.animationDuration = 1.0
        pulse?.backgroundColor = UIColor(red: 0.961, green: 0, blue: 0.722, alpha: 1).cgColor
        if let pulse{
            notificationView.layer.insertSublayer(pulse, below: notificationView.layer)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
