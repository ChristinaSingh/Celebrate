//
//  SendGiftsIntroViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 21/12/2024.
//

import Foundation
import UIKit
import SnapKit


class SendGiftsIntroViewController: BaseViewController {
    
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
        lbl.text = "Send Love Across Miles: Easy Gift Delivery for Your Loved Ones!".localized
        lbl.textColor = .accent
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.sizeToFit()
        return lbl
    }()
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Distance shouldn’t dim the brightness of your affection.".localized
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
        img.image = UIImage(named: "gift_intro")
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    
    private let message1Lbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "With our seamless gift delivery service, you can spread joy and warmth to your loved ones, no matter where they are.".localized
        lbl.textColor = .secondary
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 24)
        lbl.sizeToFit()
        return lbl
    }()
    
    private let message2Lbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Whether it's a birthday, anniversary, or just a gesture of love, let us help you make their day extra special.".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: 20)
        lbl.sizeToFit()
        return lbl
    }()
    
    private var selectedDate:Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    
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
        
        [welcomeLbl, image1, messageLbl, message1Lbl, message2Lbl].forEach { view in
            self.contentView.addSubview(view)
        }
        
        welcomeLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(32)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.welcomeLbl.snp.bottom).offset(24)
        }
        
        image1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.messageLbl.snp.bottom).offset(24)
            make.height.equalTo(240)
        }
        
        message1Lbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.image1.snp.bottom).offset(24)
        }
        
        message2Lbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.message1Lbl.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    
    override func actions() {
        backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        saveBtn.tap = {
            CalendarViewController.show(on: self, cartType: .gift, selectedDate: self.selectedDate, delegate: self)
        }
    }
}

extension SendGiftsIntroViewController: DaySelectionDelegate {
    func dayDidSelected(day: Day?) {
        guard let date = day?.date else { return }
        self.selectedDate = date
        let vc = DeliveryTimeViewController(delegate: self)
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
    
    func timeDidSelected(time: PreferredTime?) {
        let vc = SendGiftFriendsViewController(date: self.selectedDate, time: time)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
