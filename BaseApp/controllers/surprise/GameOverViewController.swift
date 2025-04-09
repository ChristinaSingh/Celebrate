//
//  GameOverViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/11/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class GameOverViewController: UIViewController {
    
    private let viewModel:SurpriseViewModel = SurpriseViewModel()
    open var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let canRevive:Bool
    init(canRevive: Bool) {
        self.canRevive = canRevive
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    
    private let imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "loss")
        return imgView
    }()
    
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Gameover!".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        label.textColor = .white
        return label
    }()
    
    
    private let subtitleLabel:UILabel = {
        let label = UILabel()
        label.text = "You failed to complete the challenge. Need another try to even the odds?".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var pulse :PulseAnimation?
    private let reviveView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 80
        view.clipsToBounds = false
        return view
    }()
    
    
    private let reviveIcon:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "revive")
        return imgView
    }()
    
    
    private let reviveLabel:UILabel = {
        let label = UILabel()
        label.text = "Tap & Hold to Revive".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        label.textColor = .accent
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    
    private let endBtn:UnderlineButton = {
        let label = UnderlineButton()
        label.setUnderlineTitle("No, I’m done!".localized, for: .normal)
        label.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.setTitleColor(.white, for: .normal)
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [imgView, titleLabel, subtitleLabel].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(137)
            make.top.equalToSuperview().offset(96)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imgView.snp.bottom).offset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
        
        if self.canRevive {
            
            [reviveIcon, reviveLabel].forEach { view in
                self.reviveView.addSubview(view)
            }
            
            reviveIcon.snp.makeConstraints { make in
                make.width.height.equalTo(48)
                make.top.equalTo(16)
                make.centerX.equalToSuperview()
            }
            
            reviveLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.reviveIcon.snp.bottom).offset(10)
            }
            
            self.backgroundView.addSubview(reviveView)
            
            reviveView.snp.makeConstraints { make in
                make.width.height.equalTo(160)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.subtitleLabel.snp.bottom).offset(70)
            }
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            longPressGesture.minimumPressDuration = 0.5
            reviveView.addGestureRecognizer(longPressGesture)
            
            self.backgroundView.addSubview(endBtn)
            endBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.reviveView.snp.bottom).offset(50)
            }
            
            endBtn.tap {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        self.viewModel.$revive.dropFirst().receive(on: DispatchQueue.main).sink { res in
            if res?.status?.string.lowercased() == "success".lowercased() {
                let vc = SurpriseQuestionsVewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                MainHelper.showErrorMessage(message: "invalid_code".localized)
            }
        }.store(in: &cancellables)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.canRevive, pulse == nil {
            let position = CGPoint(x: reviveView.frame.midX + 80, y: reviveView.frame.midY + 80)
            self.pulse = createAnimation(position: position, raduis: 140, animationDuration: 1)
            if let pulse = self.pulse {
                self.reviveView.layer.insertSublayer(pulse, at: 0)
                self.reviveView.layer.insertSublayer(createAnimation(position: position, raduis: 160, animationDuration: 2), at: 0)
                self.reviveView.layer.insertSublayer(createAnimation(position: position, raduis: 180, animationDuration: 3), at: 0)
            }
        }
    }
    
    func createAnimation(position:CGPoint, raduis:CGFloat, animationDuration:CGFloat) -> PulseAnimation {
        let pulse = PulseAnimation(numberOfPulse: .infinity, radius: raduis, postion: position)
        pulse.animationDuration = animationDuration
        pulse.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        pulse.removeAllAnimations()
        pulse.isAnimating = true
        return pulse
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            performAction()
        }
    }
    
    func performAction() {
        let vc = QRCodeScannerViewController()
        vc.isModalInPresentation = true
        vc.callback = { result in
            self.viewModel.revive(code: result)
        }
        self.present(vc, animated: true)
    }
}
