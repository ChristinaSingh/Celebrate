//
//  WinnerGameViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 08/11/2024.
//

import Foundation
import UIKit
import SnapKit


class WinnerGameViewController: UIViewController, ScratchViewDelegate {
    
    
    private let closinglocation: Closinglocation?
    
    init(closinglocation: Closinglocation?) {
        self.closinglocation = closinglocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    
    private let scratchView:ScratchView = {
        let view = ScratchView(frame: CGRect(x: 0, y: 0, width: 297, height: 297))
        return view
    }()
    
    
    private let successImg:UIImageView = {
        let img = UIImageView(image: UIImage(named: "success"))
        return img
    }()
    
    
    private let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "Congrats!".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.textColor = .white
        return lbl
    }()
    
    
    private let subTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "You have successfully completed the challenge to reveal the event's location".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let swipeImg:UIImageView = {
        let img = UIImageView(image: UIImage(named: "swipe_right_gesture"))
        return img
    }()
    
    private let scratchTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "Scratch the above card to reveal the location".localized
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let locationImg:UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 40
        return img
    }()
    
    
    private let locationLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    private let locationView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [successImg, titleLbl, subTitleLbl, locationView ,scratchView, swipeImg, scratchTitleLbl].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        successImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
            make.top.equalToSuperview().offset(80)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.successImg.snp.bottom).offset(16)
        }
        
        subTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
        }
        
        scratchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(297)
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(16)
        }
        
        locationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(297)
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(16)
        }
        
        [locationImg, locationLbl].forEach { view in
            self.locationView.addSubview(view)
        }
        
        if let closinglocation = closinglocation {
            if AppLanguage.isArabic() {
                locationLbl.text = closinglocation.closinglocationtextAr
            }else{
                locationLbl.text = closinglocation.closinglocationtext
            }
            locationLbl.underlineWithColor(color: .white)
            locationImg.download(imagePath: closinglocation.closinglocationimg ?? "", size: CGSize(width: 80, height: 80))
        }
        
        locationImg.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        locationLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.locationImg.snp.bottom).offset(20)
        }
        
        swipeImg.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.scratchView.snp.bottom).offset(10)
        }
        
        scratchTitleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.swipeImg.snp.bottom).offset(6)
        }
        
        scratchView.isUserInteractionEnabled = true
        scratchView.lineWidth = 40.0
        scratchView.delegate = self
        scratchView.image = UIImage(named: "sratchImg")
        
        locationLbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        locationLbl.addGestureRecognizer(tapGesture)
    }
    
    func scratchCardEraseProgress(eraseProgress: Float) {
        if eraseProgress > 50.0{
            UIView.animate(withDuration: 0.5, animations: {
                self.scratchView.alpha = 0.0
            })
        }
    }
    
    @objc private func labelTapped() {
        if let closinglocation = closinglocation {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(closinglocation.closinglocationLat ?? ""),\(closinglocation.closinglocationLon ?? "")&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(closinglocation.closinglocationLat ?? ""),\(closinglocation.closinglocationLon ?? "")&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
