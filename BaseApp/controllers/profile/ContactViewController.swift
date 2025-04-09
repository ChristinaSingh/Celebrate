//
//  ContactViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit

class ContactViewController: UIViewController {
    
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
    
    
    let headerView:HeaderView = {
        let view = HeaderView(title: "Contact us".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let hintView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 0.1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    
    private let whatsappIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "whatsapp")
        return img
    }()
    
    
    private let hintTitleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.numberOfLines = 2
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.text = "Need help with something?".localized
        return lbl
    }()
    
    
    private let hintMessageLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.numberOfLines = 2
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.text = "Chat with one of our representatives on Whatsapp".localized
        return lbl
    }()
    
    
    
    private let startChatBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Start chat".localized, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 12)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()
    
    
    private let nameLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Name".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    lazy var nameTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.delegate = self
        return textfield
    }()
    
    
    private let emailLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Email".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    lazy var emailTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.isEmail = true
        textfield.delegate = self
        return textfield
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
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Message".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    private let messageCounterLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.text = "0/150"
        return lbl
    }()
    
    lazy private var messageTV:PaddedTextView = {
        let textview = PaddedTextView()
        textview.layer.cornerRadius = 8
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        textview.clipsToBounds = true
        textview.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        textview.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        textview.textAlignment = AppLanguage.isArabic() ? .right : .left
        textview.delegate = self
        return textview
    }()
    
    
    private let sendMessageCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    private lazy var sendMessageBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Send message".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    
    private var isValidEmail:Bool = false
    private var isValidPhone:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    
    private func setupViews() {
        self.view.backgroundColor = .white
        headerView.back(vc: self)
        [headerView, scrollView, sendMessageCardView].forEach { view in
            self.view.addSubview(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        sendMessageCardView.addSubview(sendMessageBtn)
        sendMessageBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        sendMessageCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        

        [hintView, nameLbl, nameTF, emailLbl, emailTF, mobileNumberLbl, mobileNumberTF, messageLbl, messageCounterLbl, messageTV].forEach { view in
            self.contentView.addSubview(view)
        }
        hintView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
            make.top.equalToSuperview().offset(16)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.hintView.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        nameTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.nameLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        emailLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.nameTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        emailTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.emailLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        mobileNumberLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.emailTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        mobileNumberTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.mobileNumberLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.mobileNumberTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        messageCounterLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.messageLbl.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(18)
        }
        messageTV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.messageLbl.snp.bottom).offset(8)
            make.height.equalTo(121)
            make.bottom.equalToSuperview()
        }
        
        [whatsappIcon, hintTitleLbl, hintMessageLbl, startChatBtn].forEach { view in
            self.hintView.addSubview(view)
        }
        
        whatsappIcon.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(22)
        }
        
        hintTitleLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.whatsappIcon.snp.trailing).offset(8)
            make.centerY.equalTo(self.whatsappIcon.snp.centerY)
        }
        
        hintMessageLbl.snp.makeConstraints { make in
            make.leading.equalTo(self.whatsappIcon)
            make.top.equalTo(self.hintTitleLbl.snp.bottom).offset(8)
        }
        
        startChatBtn.snp.makeConstraints { make in
            make.leading.equalTo(self.whatsappIcon)
            make.top.equalTo(self.hintMessageLbl.snp.bottom).offset(8)
            make.width.equalTo(90)
            make.height.equalTo(32)
        }
        
        startChatBtn.tap {
            self.startChating()
        }
        
        sendMessageBtn.tap = {
            self.sendMessage()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(98)
            make.bottom.equalTo(self.sendMessageCardView.snp.top).offset(10)
        }
    }
    

    
    private func startChating() {
        let urlWhats = "whatsapp://send?phone=+96565656679"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+96565656679")
                    if UIApplication.shared.canOpenURL(whatsappURL!) {
                        UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    
    private func sendMessage(){
        sendMessageBtn.loading(true)
        ContactUsControllerAPI.contactUs(name: nameTF.textfield.text ?? "", email: emailTF.textfield.text ?? "", mobile: mobileNumberTF.textfield.text ?? "", message: messageTV.text){ res, error in
            DispatchQueue.main.async {
                self.sendMessageBtn.loading(false)
                if let error = error{
                    MainHelper.handleApiError(error)
                }else if let _ = res{
                    let vc = AuthWelcomeViewController(service: .contactus)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

}
extension ContactViewController:UITextViewDelegate, InputValidationDelegate, UITextFieldDelegate {
    func isValidEmail(_ isValid: Bool) {
        self.isValidEmail = isValid
        enableDisableSendBtn()
    }
    
    func isValidPhone(_ isValid: Bool) {
        self.isValidPhone = isValid
        enableDisableSendBtn()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        messageCounterLbl.text = "\(updatedText.count)/\(150)"
        enableDisableSendBtn()
        return updatedText.count <= 149
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enableDisableSendBtn()
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        enableDisableSendBtn()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableDisableSendBtn()
    }
    
    
    
    func isValidForm() -> Bool {
        if nameTF.textfield.text?.isEmpty == true {
            return false
        }
        
        if !isValidEmail {
            return false
        }
        
        if !isValidPhone {
            return false
        }
        
        if self.messageTV.text.isEmpty{
            return false
        }
        return true
    }
    
    
    func enableDisableSendBtn() {
        self.sendMessageBtn.enableDisableSaveButton(isEnable: isValidForm())
    }
}
