//
//  SettingsCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit

class SettingsCell: UITableViewCell {

    
    private let iconContainer:UIView = {
        let view = UIView()
        view.alpha = 0.03
        view.layer.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1).cgColor
        view.layer.cornerRadius = 24
        return view
    }()
    
    
    private let icon:UIImageView = {
        let img = UIImageView()
        return img
    }()
    

    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        return lbl
    }()
    
    
    let subTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        return lbl
    }()
    
    
    let changeBtn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        btn.setTitleColor(.accent, for: .normal)
        btn.setTitle("Change".localized.uppercased(), for: .normal)
        return btn
    }()
    
    
    private let notifyView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.961, green: 0, blue: 0.722, alpha: 1).cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    private let forwardIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "forward")
        return img
    }()
    
    
    
    private let lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let toggle:UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return toggle
    }()
    
    
    let button:UIButton = {
        let btn = UIButton()
        btn.setTitle(AppLanguage.isArabic() ? "English" : "عرب", for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .DINP, fontWeight: .bold, size: 16)
        btn.setTitleColor(UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1), for: .normal)
        return btn
    }()
    
    private let loadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return loading
    }()
    
    
    private let changeLoadingView:CircleStrokeSpinView = {
        let loading = CircleStrokeSpinView()
        loading.color = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return loading
    }()
    
    
    var setting:SettingModel?{
        didSet{
            guard let setting = setting else {return}
            icon.image = setting.icon
            titleLbl.text = setting.title
            notifyView.isHidden = !setting.notify
            forwardIcon.isHidden = setting.toggle || setting.isButton
            button.isHidden = !setting.isButton
            if setting.toggle {
                if setting.isLoading {
                    toggle.isHidden = true
                    loadingView.isHidden = false
                    changeBtn.isHidden = setting.address == nil
                    changeLoadingView.isHidden = true
                }else if setting.isChangeLoading {
                    toggle.isHidden = false
                    changeBtn.isHidden = true
                    changeLoadingView.isHidden = false
                    loadingView.isHidden = true
                }else{
                    toggle.isHidden = false
                    loadingView.isHidden = true
                    changeLoadingView.isHidden = true
                    changeBtn.isHidden = setting.address == nil
                }
            }else{
                toggle.isHidden = true
                loadingView.isHidden = true
            }
            toggle.isOn = setting.isOn
            self.selectionStyle = switch setting.setting {
            case .makeProfilePublic, .allowFriendsToPlanEvents, .language, .darkMode:
                    .none
            default:
                    .default
            }
        }
    }
    
    var address:Address?{
        didSet{
            if address == nil {
                iconContainer.snp.remakeConstraints { make in
                    make.width.height.equalTo(48)
                    make.top.bottom.equalToSuperview().inset(24)
                    make.leading.equalToSuperview().offset(16)
                }
                subTitleLbl.removeFromSuperview()
                changeBtn.removeFromSuperview()
                changeLoadingView.removeFromSuperview()
            }else {
                self.contentView.addSubview(subTitleLbl)
                self.contentView.addSubview(changeBtn)
                self.contentView.addSubview(changeLoadingView)
                subTitleLbl.text = address?.name
                iconContainer.snp.remakeConstraints { make in
                    make.width.height.equalTo(48)
                    make.top.equalToSuperview().inset(24)
                    make.leading.equalToSuperview().offset(16)
                }
                subTitleLbl.snp.makeConstraints { make in
                    make.leading.equalTo(self.titleLbl.snp.leading)
                    make.top.equalTo(self.titleLbl.snp.bottom).offset(12)
                    make.height.equalTo(18)
                }
                changeBtn.snp.makeConstraints { make in
                    make.leading.equalTo(self.titleLbl.snp.leading)
                    make.top.equalTo(self.subTitleLbl.snp.bottom).offset(16)
                    make.height.equalTo(22)
                    make.bottom.equalToSuperview().offset(-24)
                }
                
                changeLoadingView.snp.makeConstraints { make in
                    make.leading.equalTo(self.titleLbl.snp.leading)
                    make.top.equalTo(self.subTitleLbl.snp.bottom).offset(16)
                    make.width.height.equalTo(22)
                    make.bottom.equalToSuperview().offset(-24)
                }
            }
        }
    }
    
    var isLast:Bool = false{
        didSet{
            lineView.isHidden = isLast
        }
    }
    
    var callback:((Address?, Bool) -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [iconContainer, icon, titleLbl, notifyView, forwardIcon, loadingView, toggle, button, lineView].forEach { view in
            self.contentView.addSubview(view)
        }
        
        iconContainer.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.bottom.equalToSuperview().inset(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        icon.snp.makeConstraints { make in
            make.center.equalTo(self.iconContainer)
            make.width.height.equalTo(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.iconContainer)
            make.leading.equalTo(self.iconContainer.snp.trailing).offset(16)
        }
        
        forwardIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        toggle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        notifyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.forwardIcon.snp.leading).offset(-16)
            make.width.height.equalTo(8)
        }
    
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        toggle.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    
    @objc func valueChanged(){
        self.callback?(address, self.toggle.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
