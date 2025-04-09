//
//  IntroViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import UIKit
import SnapKit

struct Intro {
    let title:String?
    let image:UIImage?
    let size:CGSize
    
    init(title: String?, image: UIImage?, size: CGSize) {
        self.title = title
        self.image = image
        self.size = size
    }
}

class IntroViewController: BaseViewController {
    
    
    let step1View:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    let step2View:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    let step3View:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    let stepsIndicatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    lazy private var stepsView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [step1View, step2View, step3View])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let emailIcon:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "email"), for: .normal)
        return btn
    }()
    
    
    private let languageBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("عرب", for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .DINP, fontWeight: .bold, size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.contentEdgeInsets = .zero
        return btn
    }()
    
    
    private var collectionView:UICollectionView!
    
    private let createBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 28
        btn.backgroundColor = .white
        btn.setTitle("Create an account".localized)
        btn.setTitleColor(.black, for: .normal)
        btn.contentEdgeInsets = .zero
        return btn
    }()
    
    
    private let loginBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Login".localized)
        btn.setTitleColor(.white, for: .normal)
        btn.contentEdgeInsets = .zero
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 28
        return btn
    }()
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    
    private var intro:[Intro] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCV()
        setupIntro()
        UserDefaults.standard.setValue(true, forKey: "introduced")
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let actionsStackView:UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [loginBtn, createBtn])
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            return stackView
        }()
        
        [emailIcon , languageBtn, stepsView, stepsIndicatorView, collectionView  , actionsStackView].forEach { view in
            self.view.addSubview(view)
        }
    
        emailIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        languageBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        stepsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.emailIcon.snp.bottom).offset(25)
            make.height.equalTo(4)
        }
        
        stepsIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(self.emailIcon.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo((self.view.frame.width - 40) / 3)
            make.height.equalTo(4)
        }
        
        actionsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.height.equalTo(56)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.stepsView.snp.bottom).offset(48)
            make.bottom.equalTo(actionsStackView.snp.top).offset(-8)
        }
        
       
        languageBtn.tap {
            self.changeLanguage()
            self.setupIntro()
        }
        
        emailIcon.tap {
            let vc = ContactViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupCV(){
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout()  : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnBoardingCell.self, forCellWithReuseIdentifier: OnBoardingCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupIntro(){
        intro = [
            Intro(title: "Ready to Celebrate? Let’s make every moment unforgettable!".localized, image: UIImage(named: "image1"), size: CGSize(width: 392, height: 219)),
            Intro(title: "Wide range of products! Start planning your perfect celebration now.".localized, image: UIImage(named: "image2"), size: CGSize(width: 297, height: 216)),
            Intro(title: "Let’s get the party started! Find everything you need for an amazing event.".localized, image: UIImage(named: "image3"), size: CGSize(width: 220, height: 220))
        ]
        setupCV()
        self.collectionView.reloadData()
        self.loginBtn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        self.loginBtn.setTitle("Login".localized, for: .normal)
        self.createBtn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        self.createBtn.setTitle("Create an account".localized, for: .normal)
        self.languageBtn.setTitle(AppLanguage.isArabic() ? "English" : "عربي", for: .normal)
    }

    override func actions() {
        createBtn.tap {
            self.navigationController?.pushViewController(MobileNumberViewController(service: .Register), animated: true)
        }
        
        loginBtn.tap {
            self.navigationController?.pushViewController(MobileNumberViewController(service: .Login), animated: true)
        }
    }

}


extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCell.identifier, for: indexPath) as! OnBoardingCell
        cell.intro = intro.get(at: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        if pageIndex == 0 {
           UIView.animate(withDuration: 0.3) {
               self.stepsIndicatorView.frame.origin.x = self.step1View.frame.origin.x + 14
           }
       }else if pageIndex == 1 {
            UIView.animate(withDuration: 0.3) {
                self.stepsIndicatorView.frame.origin.x = self.step2View.frame.origin.x + 14
            }
        }else if pageIndex == 2 {
            UIView.animate(withDuration: 0.3) {
                self.stepsIndicatorView.frame.origin.x = self.step3View.frame.origin.x + 14
            }
        }
    }
}
