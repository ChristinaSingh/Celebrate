//
//  AuthWelcomeViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit

class AuthWelcomeViewController: BaseViewController {
    
    let service:Service
    
    init(service: Service) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let icon:UIImageView = {
       
        let icon = UIImageView()
        icon.image = UIImage(systemName: "checkmark")
        return icon
        
    }()
    
    
    private let card:CardView = {
        let card = CardView()
        card.cornerRadius = 50.constraintMultiplierTargetValue.relativeToIphone8Height()
        card.shadowOffsetHeight = 3
        card.shadowOffsetWidth = 3
        card.shadowOpacity = 0.5
        card.backgroundColor = UIColor(named: "SecondaryColor")
        card.shadowColor = .black
        return card
    }()
    

    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 25)
        lbl.text = "Your account is ready".localized
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 17)
        lbl.text = "Let the shopping begin!".localized
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    override func setup() {
        
        view.backgroundColor = UIColor(named: "AccentColor")
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        card.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        [card , titleLbl , messageLbl].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        
        card.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.top.equalToSuperview().offset(330.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.card.snp.bottom).offset(24.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        
        messageLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            switch self.service {
            case .Login , .Register:
                //save logged user details
                let vc = AppTabsViewController()
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.changeRootViewController(vc)
                }
                break
            case .ForgetPassword:
                if let vc = self.navigationController?.viewControllers.first(where: { $0 is MobileNumberViewController}) {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            case .contactus, .BookedPlanner, .PlanEvent , .Surprise, .Rate, .none:
                self.navigationController?.popToRootViewController(animated: true)
            case .UpdateEmail, .UpdatePhone:
                if let vc = self.navigationController?.viewControllers.first(where: { $0 is SettingsViewController}) {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        
        changeTitles()
        
    }
    
    
    
    private func changeTitles(){
        switch service {
        case .Login:
            titleLbl.text = "\("Welcome".localized) \(User.load()?.details?.username ?? "")"
            messageLbl.text = "It’s good to have you back!".localized
            card.backgroundColor = .white
            icon.image = UIImage(named: "celebrate")
            icon.contentMode = .scaleToFill
            icon.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(8)
            }
        case .Register:
            titleLbl.text = "Your account is ready".localized
            messageLbl.text = "Let the shopping begin!".localized
            card.backgroundColor = .white
            icon.image = UIImage(named: "celebrate")
            icon.contentMode = .scaleToFill
            icon.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(8)
            }
        case .ForgetPassword:
            titleLbl.text = "Password reset done".localized
            messageLbl.text = "Let the shopping begin!".localized
            card.backgroundColor = UIColor(named: "SecondaryColor")
            icon.image = UIImage(systemName: "checkmark" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
            icon.tintColor = .white
            break
        case .contactus:
            titleLbl.text = "Message sent!".localized
            messageLbl.text = "A customer representative will get back to you within 48 hours".localized
            messageLbl.numberOfLines = 2
            messageLbl.textAlignment = .center
            card.backgroundColor = UIColor(named: "SecondaryColor")
            icon.image = UIImage(systemName: "checkmark" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
            icon.tintColor = .white
        case .UpdatePhone:
            titleLbl.text = "Number updated".localized
            messageLbl.text = "We’ve verified your mobile number and you are good to go".localized
            card.backgroundColor = UIColor(named: "SecondaryColor")
            icon.image = UIImage(systemName: "checkmark" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
            icon.tintColor = .white
        case .UpdateEmail:
            titleLbl.text = "Email updated".localized
            messageLbl.text = "We’ll get back to you".localized
            card.backgroundColor = UIColor(named: "SecondaryColor")
            icon.image = UIImage(systemName: "checkmark" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
            icon.tintColor = .white
        case .BookedPlanner, .PlanEvent, .Surprise:
            titleLbl.text = "Enquiry submitted".localized
            messageLbl.text = "We’ll get back to you".localized
            card.backgroundColor = UIColor(named: "SecondaryColor")
            icon.image = UIImage(systemName: "checkmark" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
            icon.tintColor = .white
        case .Rate:
            titleLbl.text = "Thank you!".localized
            messageLbl.text = "We appreciate you rating the order and help us improve".localized
            card.backgroundColor = UIColor(named: "SecondaryColor")
            icon.image = UIImage(systemName: "checkmark" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
            icon.tintColor = .white
        case .none:
            break
        }
    }

}
