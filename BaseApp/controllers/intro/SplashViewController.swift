//
//  ViewController.swift
//  BaseApp
//
//  Created by Ehab on 13/03/2024.
//

import UIKit
import SnapKit

class SplashViewController: BaseViewController {
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()

    private let img:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "splash")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    private let logo:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "white_logo")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func setup() {
        view.backgroundColor = UIColor(named: "AccentColor")
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [img , logo].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        img.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        logo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(128)
            make.leading.trailing.equalToSuperview()
        }
        
        AppUpdateManager.shared.fetchVersionInfo { [weak self] (latestVersion) in
            guard let self = self else { return }
            if let latestVersion = latestVersion,
               let currentVersion = AppUpdateManager.shared.getCurrentAppVersion() {
                if AppUpdateManager.shared.isVersionOutdated(currentVersion: currentVersion, latestVersion: latestVersion) {
                    AppUpdateManager.shared.showForceUpdatePopup()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        if let _ = User.load()?.details {
                            let vc = AppTabsViewController()
                            if let sceneDelegate = UIApplication.shared.connectedScenes
                                .first?.delegate as? SceneDelegate {
                                sceneDelegate.changeRootViewController(vc)
                            }
                        }else{
                            let intro = IntroViewController()
                            let nav = UINavigationController(rootViewController: intro)
                            nav.modalPresentationStyle = .fullScreen
                            nav.modalTransitionStyle = .crossDissolve
                            nav.setNavigationBarHidden(true, animated: false)
                            self.present(nav, animated: true)
                        }
                    }
                }
            }
        }
    }
}

