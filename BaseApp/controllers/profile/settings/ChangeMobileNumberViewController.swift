//
//  ChangeMobileNumberViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit

class ChangeMobileNumberViewController: BaseViewController {
    
    private var bottomViewBottomConstraint: Constraint?
    private var keyboardManager: KeyboardManager?
    private let viewModel:AuthViewModel = AuthViewModel()
    private var isValidPhone:Bool = false
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Change mobile no.".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor =  UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let mobileNumberLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Mobile number".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    lazy var mobileNumberTF:C8InputView = {
        let textfield = C8InputView()
        textfield.isPhone = true
        textfield.delegate = self
        textfield.backgroundColor = .white
        return textfield
    }()
    
    
    private let newMobileNumberLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "New Mobile number".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    lazy var newMobileNumberTF:C8InputView = {
        let textfield = C8InputView()
        textfield.isPhone = true
        textfield.delegate = self
        textfield.backgroundColor = .white
        return textfield
    }()
    

    private let saveCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    private lazy var saveBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Save".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    var callback:((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.cancel(vc: self)
        [headerView , scrollView, saveCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        saveCardView.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        saveCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(101)
            bottomViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.saveCardView.snp.top).offset(10)
        }
        
        [mobileNumberLbl, mobileNumberTF, newMobileNumberLbl, newMobileNumberTF].forEach { view in
            self.contentView.addSubview(view)
        }
        
        mobileNumberLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(18)
        }
        
        mobileNumberTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.mobileNumberLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        newMobileNumberLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(self.mobileNumberTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        newMobileNumberTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.newMobileNumberLbl.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(48)
        }
        
    }
    
    override func actions() {
        self.saveBtn.tap = {
            self.viewModel.checkIfMobileNumberExists(phoneNumber: self.newMobileNumberTF.text ?? "", otpRequired: true)
        }
    }
    
    
    override func observers() {
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$checkIfMobileNumberExists.receive(on: DispatchQueue.main).sink { otp in
            if otp?.status?.boolean == false && otp?.message?.lowercased() == "success".lowercased(){
                self.dismiss(animated: true) {
                    self.callback?(self.newMobileNumberTF.text ?? "")
                }
            }else if let data = otp?.data{
                MainHelper.showToastMessage(message: data, style: .error, position: .Bottom)
            }
        }.store(in: &cancellables)
    }
    
    override func keyboardOpened(with height: CGFloat) {
        saveCardView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-height)
            make.height.equalTo(80)
        }
    }
    
    override func keyboardClosed(with height: CGFloat) {
        saveCardView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
    }

}
extension ChangeMobileNumberViewController:InputValidationDelegate {
    func isValidPhone(_ isValid: Bool) {
        self.isValidPhone = isValid
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // enableDisableSendBtn()
        return true
    }
    
    func enableDisableSendBtn() {
        self.saveBtn.enableDisableSaveButton(isEnable: isValidForm())
    }
    
    func isValidForm() -> Bool {
       
        return true
    }
    
}
