//
//  TermsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 05/12/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class ReplacementViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:PlanEventViewModel = PlanEventViewModel()
    let service:Service
    let appid:String
    init(service: Service, appid:String) {
        self.service = service
        self.appid = appid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Find replacement?".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "replacement")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Planner Availability".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 20)
        label.textColor = .accent
        return label
    }()
    
    private let subTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "We understand how important your event is. Just incase If your chosen event planner becomes unavailable, don’t worry!".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    let checklistItems = [
        "Similar style and expertise".localized,
        "Exceptional attention to detail".localized,
        "Commitment to making your event unforgettable".localized
    ]
    
    
    lazy var checklistView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        for item in checklistItems {
            let contentView = UIView()
            
            let icon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            icon.tintColor = .accent
            contentView.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview()
                make.width.height.equalTo(24)
            }
            
            let label = UILabel()
            label.text = item
            label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
            label.textColor = .accent
            contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(icon.snp.trailing).offset(8)
            }
            stackView.addArrangedSubview(contentView)
        }
        return stackView
    }()
    
    
    private let nextTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "What Happens Next?".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textColor = .black
        return label
    }()
    
    private let nextValueLabel:UILabel = {
        let label = UILabel()
        label.text = "We notify you immediately about the change.".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textColor = .accent
        label.numberOfLines = 0
        return label
    }()
    
    private let nextTitle1Label:UILabel = {
        let label = UILabel()
        label.text = "Your event’s success is our top priority!".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        label.textColor = .black
        return label
    }()
    
    private let checkBoxBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        btn.tintColor = .accent
        return btn
    }()
    
    private let checkBoxLabel:UILabel = {
        let label = UILabel()
        label.text = "I don’t want a replacement".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        label.textColor = .black
        return label
    }()
    
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        return view
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    
    private let proceedCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    lazy var proceedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        headerView.back(vc: self)
        // Add subviews to the main view
        [headerView, scrollView,checkBoxBtn, checkBoxLabel ,proceedCardView].forEach { view in
            self.view.addSubview(view)
        }

        // Header View Constraints
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(98)
        }

        // Proceed Button inside Card
        proceedCardView.addSubview(self.proceedBtn)
        self.proceedBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        // Proceed Card View Constraints
        proceedCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101) // Ensure consistent height
        }

        // Scroll View Constraints
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.proceedCardView.snp.top) // Attach to the top of the button view
        }

        // Content View inside ScrollView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Fill the scroll view
            make.width.equalTo(scrollView) // Match scroll view width
        }

        // Add subviews to contentView
        [imageView, titleLabel, subTitleLabel, checklistView, nextTitleLabel, nextValueLabel, nextTitle1Label].forEach { view in
            self.contentView.addSubview(view)
        }

        // Image View Constraints
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20) // Add top padding
            make.width.equalTo(168)
            make.height.equalTo(48)
        }

        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.imageView.snp.bottom).offset(24)
        }

        // Subtitle Label Constraints
        subTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }

        // Checklist View Constraints
        checklistView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(104)
        }

        // Next Title Label Constraints
        nextTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.checklistView.snp.bottom).offset(25)
        }

        // Next Value Label Constraints
        nextValueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.nextTitleLabel.snp.bottom).offset(8)
        }

        // Final Title Label Constraints
        nextTitle1Label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.nextValueLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16) // Attach to bottom of contentView for dynamic scrolling
        }
        
        checkBoxBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(self.proceedCardView.snp.top)
            make.width.height.equalTo(24)
        }
        
        checkBoxLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.checkBoxBtn)
            make.leading.equalTo(self.checkBoxBtn.snp.trailing).offset(12)
        }
        
        checkBoxBtn.tap {
            self.checkBoxBtn.isSelected.toggle()
        }
        
        self.viewModel.$bookLoading.dropFirst().receive(on: DispatchQueue.main).sink { loading in
            self.proceedBtn.loading(loading)
        }.store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$replacement.dropFirst().receive(on: DispatchQueue.main).sink { res in
            if res?.status?.boolean == true {
                let vc = AuthWelcomeViewController(service: self.service)
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                MainHelper.showToastMessage(message: res?.message ?? "something went wrong", style: .error, position: .Top)
            }
        }.store(in: &cancellables)
        
        proceedBtn.tap = {
            self.viewModel.replacement(body: ReplacementRequest(needReplacement: self.checkBoxBtn.isSelected, applicationID: self.appid))
        }
    }
}
