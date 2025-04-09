//
//  SurpriseIntroViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/10/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class SurpriseIntroViewController: BaseViewController {
    
    
    private let viewModel:SurpriseViewModel = SurpriseViewModel()
    private var seledctedDay:Day? = nil
    private let backBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "surprise_back"), for: .normal)
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
    
    
    private let getStartedView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    lazy private var getStartedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "GET STARTED".localized.capitalized, width: (self.view.frame.width - CGFloat(48)) / 2, height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    lazy private var hasCodeBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Already have a code?".localized)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        btn.setTitleColor(.accent, for: .normal)
        btn.layer.cornerRadius = 24.constraintMultiplierTargetValue.relativeToIphone8Height()
        btn.layer.borderColor = UIColor.accent.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    
    lazy private var actionstack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hasCodeBtn, getStartedBtn])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Surprise Your Loved Ones with a Tailor-Made Event!".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: .init(32))
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    private let subTitleLabel1:UILabel = {
        let label = UILabel()
        label.text = "Whether you're envisioning a lavish wedding, a corporate gala, or an intimate gathering,".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: .init(20))
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    private let introImg:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "surprise_intro")
        return img
    }()
    
    
    private let subTitleLabel2:UILabel = {
        let label = UILabel()
        label.text = "We're here to connect you with the crème de la crème of event planners who will transform your dreams into reality.".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .light, size: .init(20))
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    private let titleLabel2:UILabel = {
        let label = UILabel()
        label.text = "Why Choose Us for Your Custom Event?".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: .init(20))
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    private let personalizationView:SurpriseServiceView = {
        let view = SurpriseServiceView()
        view.titleLabel.text = "Personalized Touch".localized
        view.icon.image = UIImage(named: "favorites_shield")
        return view
    }()
    
    
    private let seamlessPlanningView:SurpriseServiceView = {
        let view = SurpriseServiceView()
        view.titleLabel.text = "Seamless Planning".localized
        view.icon.image = UIImage(named: "sale_price_tag")
        return view
    }()
    
    
    private let unforgettableExperiencesView:SurpriseServiceView = {
        let view = SurpriseServiceView()
        view.titleLabel.text = "Unforgettable Experiences".localized
        view.icon.image = UIImage(named: "trust")
        return view
    }()
    
    
    private let expertSupportView:SurpriseServiceView = {
        let view = SurpriseServiceView()
        view.titleLabel.text = "Expert Support".localized
        view.icon.image = UIImage(named: "online_support")
        return view
    }()
    
    
    
   lazy private var prosonalizedSeamlessStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [personalizationView, seamlessPlanningView])
        stack.axis = .horizontal
        stack.spacing = 16
       stack.distribution = .fillEqually
        return stack
    }()
    
    
    lazy private var unforgettableExpertSupportStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [unforgettableExperiencesView, expertSupportView])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    lazy private var servicesStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [prosonalizedSeamlessStack, unforgettableExpertSupportStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func setup() {
        self.view.backgroundColor = .accent
        backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        [scrollView, getStartedView, backBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.width.height.equalTo(40)
        }
       
        getStartedView.addSubview(actionstack)
        actionstack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        getStartedView.snp.makeConstraints { make in
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
        
        [titleLabel, subTitleLabel1, introImg, subTitleLabel2, titleLabel2, servicesStack].forEach { view in
            self.contentView.addSubview(view)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(24)
        }
        
        subTitleLabel1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
        
        
        introImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.subTitleLabel1.snp.bottom).offset(24)
            make.height.equalTo(240)
        }
        
        subTitleLabel2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.introImg.snp.bottom).offset(24)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.subTitleLabel2.snp.bottom).offset(24)
        }
        
        servicesStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.titleLabel2.snp.bottom).offset(16)
            make.height.equalTo(308)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    
    override func actions() {
        self.backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.getStartedBtn.tap = {
            CalendarViewController.show(on: self, cartType: .ai, selectedDate: self.seledctedDay?.date ?? Date(), delegate: self)
        }
        
        self.hasCodeBtn.tap {
            let vc = SurpriseCodeVerificationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func observers() {
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.getStartedBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.viewModel.$signupResponse.receive(on: DispatchQueue.main).sink { response in
            if let res = response {
                if res.status?.string.lowercased() == "success" {
                    self.navigationController?.pushViewController(AuthWelcomeViewController(service: .Surprise), animated: true)
                }
            }
        }.store(in: &cancellables)
    }
    
}


fileprivate class SurpriseServiceView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    
    let icon:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(24)
            make.width.height.equalTo(48)
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SurpriseIntroViewController: DaySelectionDelegate{
    func dayDidSelected(day: Day?) {
        self.seledctedDay = day
        let date = DateFormatter.standard.string(from: day?.date ?? Date())
        let user = User.load()?.details
        viewModel.signUp(date:date , name: user?.username ?? "", mobile: user?.mobileNumber ?? user?.phoneNumber ?? "", additionalinfo: "")
    }
    
    func timeDidSelected(time: PreferredTime?) {}
}
