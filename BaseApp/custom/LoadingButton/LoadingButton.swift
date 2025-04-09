//
//  LoadingButton.swift
//  BaseApp
//
//  Created by Ihab yasser on 09/04/2024.
//

import Foundation
import UIKit
import SnapKit

class LoadingButton:UIView{
    
    let button:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 24.constraintMultiplierTargetValue.relativeToIphone8Height()
        btn.setTitleColor(.black, for: .normal)
        btn.alpha = 0.25
        btn.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        return btn
    }()
    
    
    let loadingView:BallRotateChaseView = {
        let view = BallRotateChaseView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24.constraintMultiplierTargetValue.relativeToIphone8Height()
        return view
    }()
    
    private var btnTitle:String = ""
    var tap:(() -> ())?
    private var isActive:Bool = false
    
    func setTitle(_ title:String) {
        btnTitle = title
        button.setTitle(title)
    }
    
    
    func setActive(_ isActive:Bool){
        self.isActive = isActive
        if isActive {
            button.alpha = 1
        }else{
            button.alpha = 0.25
        }
    }
    
    func loading(_ show:Bool, callback:(() -> ())? = nil) {
        if show {
            showLoading(callback: callback)
        } else {
            hideLoading(callback: callback)
        }
    }
    
    private func showLoading(callback:(() -> ())? = nil){
        self.button.setTitle("")
        self.button.snp.updateConstraints { make in
            make.width.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22){
                self.loadingView.isHidden = false
                self.button.isHidden = true
                callback?()
            }
        }
    }
    
    private func hideLoading(callback:(() -> ())? = nil){
        self.loadingView.isHidden = true
        self.button.isHidden = false
        self.button.snp.updateConstraints { make in
            make.width.equalTo(self.frame.width)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.button.setTitle(self.btnTitle)
            callback?()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.layer.cornerRadius = 24.constraintMultiplierTargetValue.relativeToIphone8Height()
        button.removeFromSuperview()
        loadingView.removeFromSuperview()
        self.addSubview(button)
        self.addSubview(loadingView)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.width.equalTo(self.frame.width)
        }
        loadingView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        loadingView.isHidden = true
        button.tap {
            if self.isActive {
                self.tap?()
            }
        }
    }
    
    
    class func createObject(title:String , width:CGFloat , height:CGFloat) -> LoadingButton{
        let btn = LoadingButton(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        btn.setTitle(title)
        return btn
    }
    
    func enableDisableSaveButton(isEnable:Bool){
        if isEnable {
            self.button.setTitleColor(.white, for: .normal)
            self.button.layer.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1).cgColor
            self.button.isUserInteractionEnabled = true
        }else{
            self.button.setTitleColor(UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5), for: .normal)
            self.button.layer.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
            self.button.isUserInteractionEnabled = false
        }
    }
    
    
}
