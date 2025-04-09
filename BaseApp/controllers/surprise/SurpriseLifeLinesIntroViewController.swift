//
//  SurpriseLifeLinesIntroViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/11/2024.
//

import Foundation
import UIKit
import SnapKit

class SurpriseLifeLinesIntroViewController: BaseViewController {
    
    private let onboardingType: SurpriseOnBoardingType
    
    init(onboardingType: SurpriseOnBoardingType) {
        self.onboardingType = onboardingType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "life_line")
        return imageView
    }()
    
    
    lazy private var titleLabel:UILabel = {
        let label = UILabel()
        label.text = self.onboardingType == .Basic ?  "Life Lines".localized : "All Set! We are Ready to Begin".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .extrabold, size: 64)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override func setup() {
        self.view.addSubview(backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [imageView, titleLabel].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(627)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(40)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            if self.onboardingType == .Basic {
                let vc = SurpriseOnBoardingViewController(onboardingType: .Lines)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = SurpriseQuestionsVewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
