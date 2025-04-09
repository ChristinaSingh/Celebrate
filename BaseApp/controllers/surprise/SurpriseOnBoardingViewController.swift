//
//  SurpriseOnBoardingViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/11/2024.
//

import Foundation
import UIKit
import SnapKit



class SurpriseOnBoardingViewController: BaseViewController {
    
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
    
    
    private let basicsOnboarding:[SurpriseOnBoarding] = {
        return [
            SurpriseOnBoarding(icon: UIImage(named: "lives"), title: "Lives".localized, description: "This symbol indicates how many lives you have within the experience".localized),
            SurpriseOnBoarding(icon: UIImage(named: "skips"), title: "Skips".localized, description: "This symbol indicates how many times you can skip and move ahead".localized),
            SurpriseOnBoarding(icon: UIImage(named: "completed"), title: "Completed".localized, description: "This symbol indicates how many task you’ve successfully compeleted".localized)
        ]
    }()
    
    
    private let linesOnboarding:[SurpriseOnBoarding] = {
        return [
            SurpriseOnBoarding(icon: UIImage(named: "fifty"), title: "50/50", description: "This symbol indicates how many lives you have within the experience".localized),
            SurpriseOnBoarding(icon: UIImage(named: "vasta"), title: "Vasta".localized, description: "This symbol indicates how many times you can skip and move ahead".localized)
        ]
    }()
    
    
    lazy private var onBoarding:[SurpriseOnBoarding] = {
        return if onboardingType == .Basic {
            basicsOnboarding
        }else{
            linesOnboarding
        }
    }()
    
    private let back:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: .normal)
        return btn
    }()
    
    
    lazy private var titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.textAlignment = .center
        lbl.text = onboardingType == .Basic ? "The Basics" : "Life Lines"
        return lbl
    }()
    
    lazy private var descriptionLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "Get to know how the experience works".localized
        return lbl
    }()
    
    lazy private var collectionView:UICollectionView = {
        let layout = CenterCellCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(SurpriseCardCell.self, forCellWithReuseIdentifier: SurpriseCardCell.reuseIdentifier)
        return collectionView
    }()
    
    
    private let nextBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "next"), for: .normal)
        btn.setImage(nil, for: .selected)
        btn.setTitle("Proceed".localized, for: .selected)
        btn.setTitleColor(.accent, for: .selected)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    
    private var currentIndex:Int = 0
    
    override func setup() {
        self.view.addSubview(backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [back, titleLbl, descriptionLbl, collectionView, nextBtn].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        back.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(64)
            make.width.height.equalTo(24)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.back.snp.bottom).offset(24)
        }
        
        descriptionLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(24)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.descriptionLbl.snp.bottom).offset(48)
            make.height.equalTo(416)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom).offset(48)
        }
        
    }
    
    override func actions() {
        back.tap {
            self.navigationController?.popToRootViewController(animated: true)
        }
        nextBtn.tap {
            if self.nextBtn.isSelected {
                self.navigationController?.pushViewController(SurpriseLifeLinesIntroViewController(onboardingType: self.onboardingType), animated: true)
            }else{
                self.scrollToNext()
            }
        }
    }
    
    
    private func scrollToNext() {
        currentIndex += 1
        if currentIndex < self.onBoarding.count {
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToCenteredItem(at: indexPath, animated: true)
            if currentIndex == self.onBoarding.count - 1 {
                nextBtn.isSelected = true
                nextBtn.backgroundColor = .white
                nextBtn.layer.cornerRadius = 24
                nextBtn.setImage(nil, for: .normal)
                nextBtn.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(self.collectionView.snp.bottom).offset(48)
                    make.height.equalTo(48)
                    make.width.equalTo(153)
                }
            }
        }
    }
}

extension SurpriseOnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.onBoarding.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurpriseCardCell.reuseIdentifier, for: indexPath) as! SurpriseCardCell
        cell.onBoarding = self.onBoarding[safe: indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 80, height: 416)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }

}
