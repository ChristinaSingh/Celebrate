//
//  HeaderView.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    
    var title:String{
        didSet{
            titleLbl.text = title
        }
    }
    init(title: String) {
        self.title = title
        titleLbl.text = title
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let backBtn:UIButton = {
        let btn = UIButton()
        btn.tintColor = .black
        return btn
    }()
    
    let logoutBtn:UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    
    private let searchBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "search_icon_black"), for: .normal)
        return btn
    }()
    
    let separator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    var withLogoutBtn:Bool = false {
        didSet{
            if withLogoutBtn {
                logoutBtn.isHidden = false
                logoutBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    
    var withSearchBtn:Bool = false {
        didSet{
            if withSearchBtn {
                searchBtn.isHidden = false
                searchBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    private var viewController:UIViewController?
    
    private func setup(){
        let logout = UIImage(named: "logout")
        backBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        backBtn.tintColor = .black
        logoutBtn.setImage(AppLanguage.isArabic() ? logout?.tap_mirrored : logout, for: .normal)
        
        [titleView].forEach { view in
            self.addSubview(view)
        }
        
        titleView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        [backBtn , titleLbl, logoutBtn, searchBtn, separator].forEach { view in
            self.titleView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        logoutBtn.isHidden = true
        logoutBtn.isUserInteractionEnabled = false
        logoutBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.backBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        searchBtn.isHidden = true
        searchBtn.isUserInteractionEnabled = false
        searchBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.backBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        searchBtn.tap {
            guard let viewController = self.viewController else{return}
            self.search(on: viewController)
        }
    }
    
    func back(vc:UIViewController){
        self.backBtn.tap {
            vc.navigationController?.popViewController(animated: true)
        }
        self.viewController = vc
    }
    
    
    func enableLogout(vc:UIViewController){
        ConfirmationAlert.show(on: vc, title: "Logout Confirmation".localized, message: "Are you sure you want to log out?".localized, icon:UIImage(named: "error"), positiveButtonTitle: "Logout".localized) {
            User.remove()
            let vc = IntroViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate {
                sceneDelegate.changeRootViewController(nav)
            }
        }
    }
    
    
    func search(on vc :UIViewController){
        let searchVC = SearchViewController()
        searchVC.isModalInPresentation = true
        vc.present(searchVC, animated: true)
    }
    
}
