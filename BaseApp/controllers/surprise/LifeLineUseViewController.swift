//
//  LifeLineUseViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 02/11/2024.
//

import Foundation
import UIKit
import SnapKit

class LifeLineUseViewController: BaseViewController {
    
    private let lifeLine:LifeLine
    init(lifeLine: LifeLine) {
        self.lifeLine = lifeLine
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "LIFE LINES".localized.capitalized)
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
   lazy private var titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textAlignment = .center
       lbl.text = self.lifeLine == .fiftyFifty ?  "Eliminate 2 wrong answers and increase your chances of getting the right answer".localized : "The student council's Vice President got your back this time!".localized.capitalized
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    private let subTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .accent
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        lbl.textAlignment = .center
        lbl.text = "Can be used only 1 time!".localized
        return lbl
    }()
    
    
    lazy private var cardView:UIView = {
        let view = cardShadow()
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy private var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: self.lifeLine == .fiftyFifty ? "fifty" : "vasta")
        return imageView
    }()
    
    
    lazy private var descTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .accent
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.textAlignment = .center
        lbl.text = self.lifeLine == .fiftyFifty ? "50/50" : "Wasta"
        return lbl
    }()
    
    lazy private var descriptionLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "This symbol indicates how many\ntask you’ve successfully\ncompleted".localized
        return lbl
    }()
    
    lazy private var useCardBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: self.lifeLine == .fiftyFifty ? "Use the 50/50 card".localized : "Use the vasta card".localized.capitalized, width: (self.view.frame.width - CGFloat(48)) / 2, height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    var callback:(() -> Void)?
    
    override func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        
        [headerView, titleLbl, subTitleLbl, cardView, useCardBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(24)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
        }
        
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(416.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        
        [imageView, descTitleLbl, descriptionLbl].forEach { view in
            self.cardView.addSubview(view)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(169)
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        descTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(24)
        }
        
        descriptionLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.descTitleLbl.snp.bottom).offset(24)
        }
        
        useCardBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.cardView.snp.bottom).offset(40)
            make.height.equalTo(48)
            make.width.equalTo(233)
        }
        
        useCardBtn.tap = {
            self.dismiss(animated: true) {
                self.callback?()
            }
        }
    }
    
    private func cardShadow() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 80, height: 416.constraintMultiplierTargetValue.relativeToIphone8Height())
        view.layer.cornerRadius = 30
        let shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        shadows.layer.cornerRadius = 30
        view.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 30)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor.accent.withAlphaComponent(0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 24
        layer0.shadowOffset = CGSize(width: 0, height: 40)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        let shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        shapes.layer.cornerRadius = 30
        view.addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)

        shapes.layer.cornerRadius = 30
        
        return view
    }
}
