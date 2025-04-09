//
//  CorrectAnswerViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 07/11/2024.
//

import Foundation
import UIKit
import SnapKit

enum AnswerResult {
    case correct
    case wrong
    case none
}

class AnswerResultViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private let result: AnswerResult
    private let fadeAnimator = FadeAnimator()
    init(result: AnswerResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "check_mark")
        return imageView
    }()
    
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 24)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = result == .correct ? .secondary6 : .secondary3
        self.icon.image = UIImage(named: self.result == .correct ? "check_mark" : "incorrect")
        self.titleLbl.text = self.result == .correct ? "You’ve answered the question correctly".localized : "Your answer is incorrect Never mind keep trying!".localized
        [icon, titleLbl].forEach { view in
            self.view.addSubview(view)
        }
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.centerY.equalToSuperview().offset(-80)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(20)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)  {
            self.dismiss(animated: true){
                self.callback?()
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeAnimator.isPresenting = true
        return fadeAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeAnimator.isPresenting = false
        return fadeAnimator
    }

}
