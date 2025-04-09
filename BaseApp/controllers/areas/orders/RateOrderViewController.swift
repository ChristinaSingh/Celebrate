//
//  RateOrderViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/12/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class RateOrderViewController: UIViewController, UITextViewDelegate {
    
    let order:Order?
    let viewModel: OrdersViewModel
    private var cancellables: Set<AnyCancellable>
    init(order: Order?) {
        self.viewModel = OrdersViewModel()
        self.order = order
        self.cancellables = Set<AnyCancellable>()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var bottomViewBottomConstraint: Constraint?
    private var keyboardManager: KeyboardManager?
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Rate the order".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
   lazy private var titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 1)
       lbl.text = "\("Order from Company name".localized) \(order?.vendor?.name ?? "")"
        return lbl
    }()
    
    
    private let commentView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    private let commentHeader:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    
    private let commentTitleLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 1)
        lbl.text = "Add a detailed review".localized
        return lbl
    }()
    
    
    private let charCountLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .accent
        lbl.text = "0/150"
        return lbl
    }()
    
    private let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 0.1)
        return view
    }()
    
    lazy private var commentTV:PlaceholderTextView = {
        let tv = PlaceholderTextView()
        tv.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        tv.placeholderFont = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        tv.placeholderColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 0.5)
        tv.placeholder = "".localized
        tv.textColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 1)
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.delegate = self
        return tv
    }()
    
    private let rateView:EmojiRatingView = {
        let view = EmojiRatingView()
        return view
    }()
    
    private let submitCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    lazy var submitBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Submit".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    var callback:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [headerView].forEach { view in
            self.containerView.addSubview(headerView)
        }
        headerView.cancel(vc: self)
        [headerView, titleLbl, rateView, commentView, submitCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(24)
        }
        
        rateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
        }
        
        commentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.rateView.snp.bottom).offset(32)
            make.height.equalTo(177)
        }
        
        [commentHeader, commentTV].forEach { view in
            self.commentView.addSubview(view)
        }
        
        commentHeader.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(54)
        }
        
        commentTV.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(self.commentHeader.snp.bottom).offset(16)
        }
        
        [commentTitleLbl, charCountLbl, separatorView].forEach { view in
            self.commentHeader.addSubview(view)
        }
        
        
        commentTitleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        charCountLbl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        submitCardView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        submitCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(101)
            bottomViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        keyboardManager = KeyboardManager(viewController: self, bottomConstraint: bottomViewBottomConstraint)
        rateView.valueDidChanged = {_ in self.enableRateBtn()}
        
        self.viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            self.submitBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.viewModel.$rateOrder.dropFirst().receive(on: DispatchQueue.main).sink { res in
            self.dismiss(animated: true) {
                self.callback?()
            }
        }.store(in: &cancellables)
        
        self.submitBtn.tap = {
            self.viewModel.rateOrder(orderId: self.order?.id ?? "", rating: "\(self.rateView.getSelectedEmoji()?.intValue() ?? 0)", comment: self.commentTV.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        charCountLbl.text = "\(updatedText.count) / \(150)"
        enableRateBtn()
        return updatedText.count <= 149
    }
    
    func enableRateBtn() {
        let isEnabled = self.commentTV.text?.count ?? 0 > 0 && self.rateView.getSelectedEmoji() != nil
        submitBtn.enableDisableSaveButton(isEnable: isEnabled)
    }
}
