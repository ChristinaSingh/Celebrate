//
//  GetStartedViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 09/09/2024.
//

import UIKit
import SnapKit


class GetStartedViewController: UIViewController {
    
    
    private var area:Area?
    private var day:Day?
    private var time:TimeSlot?
    
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
    
    
    private let welcomeLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Welcome to Your Ultimate Celebration Planner!".localized
        lbl.textColor = .accent
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.sizeToFit()
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Are you ready to elevate your celebration to extraordinary heights?".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: 20)
        lbl.sizeToFit()
        return lbl
    }()
    
    
    
    private let message2Lbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Whether it's a birthday bash, a wedding extravaganza, or a simple get-together with friends,".localized
        lbl.textColor = UIColor(red: 0.157, green: 0.78, blue: 1, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 24)
        lbl.sizeToFit()
        return lbl
    }()
    
    
    private let message3Lbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Our platform is here to make your planning process seamless and stress-free.".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: 20)
        lbl.sizeToFit()
        return lbl
    }()
    
    
    private let message4Lbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Unlock the magic of planning your perfect celebration in just four easy steps!".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: 20)
        lbl.sizeToFit()
        return lbl
    }()
    
    private let introImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "get_started")
        img.contentMode = .scaleAspectFit
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
        
        [welcomeLbl, messageLbl, introImg, message2Lbl, message3Lbl, message4Lbl].forEach { view in
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
        introImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageLbl.snp.bottom).offset(16)
            make.height.equalTo(378)
        }
        message2Lbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.introImg.snp.bottom).offset(16)
        }
        
        message3Lbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.message2Lbl.snp.bottom).offset(24)
        }
        
        message4Lbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.message3Lbl.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        saveBtn.tap = {
            AreasViewController.show(on: self, delegate: self)
        }
    }

}
extension GetStartedViewController:AreaSelectionDelegate, DaySelectionDelegate, OccasionTimeSelectionDelegate{
    func timeDidSelected(time: TimeSlot?) {
        self.time = time
        self.navigationController?.pushViewController(OccassionViewController(area: area, day: day, time: time), animated: true)
    }
    
    func dayDidSelected(day: Day?) {
        self.day = day
        OccasionTimeViewController.show(on: self, delegate: self)
    }
    
    func areaDidSelected(area: Area?) {
        self.area = area
        CalendarViewController.show(on: self, cartType: .ai, selectedDate: self.day?.date, delegate: self)
    }
}
