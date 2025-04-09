//
//  PlanEventIntroViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/09/2024.
//

import Foundation
import UIKit
import SnapKit


class PlanEventIntroViewController: UIViewController {
    
    private let backBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "get_started_back"), for: .normal)
        return button
    }()
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    private let welcomeLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Embark on an extraordinary journey of event planning excellence with our exclusive platform.".localized
        lbl.textColor = .accent
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.sizeToFit()
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "planevnt_message".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: 20)
        lbl.sizeToFit()
        return lbl
    }()
    
    private let saveCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    lazy var saveBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "GET STARTED".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    private let image1:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "planevent1")
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    
    private let image2:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "planevent2")
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    private let image3:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "planevent3")
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    private let image4:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "planeven4")
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        [scrollView, saveCardView, backBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.width.height.equalTo(40)
        }
       
        saveCardView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        saveCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(101)
            make.bottom.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.backBtn.snp.bottom).offset(8)
            make.bottom.equalTo(self.view.snp.bottom).inset(101)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        [welcomeLbl, image1, image2, image3, image4, messageLbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        welcomeLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(32)
        }
        
        let imgWidth = (self.view.frame.width - 63) / 2
        
        image1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.welcomeLbl.snp.bottom).offset(24)
            make.width.height.equalTo(imgWidth)
        }
        
        image2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(self.image1.snp.top).offset(24)
            make.width.height.equalTo(imgWidth)
        }
        
        image3.snp.makeConstraints { make in
            make.leading.equalTo(self.image1.snp.leading)
            make.top.equalTo(self.image1.snp.bottom).offset(15)
            make.width.height.equalTo(imgWidth)
        }
        
        image4.snp.makeConstraints { make in
            make.trailing.equalTo(self.image2.snp.trailing)
            make.top.equalTo(self.image2.snp.bottom).offset(15)
            make.width.height.equalTo(imgWidth)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.image4.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        saveBtn.tap = {
            let vc = AllPlannersViewController(service: .PlanEvent)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
