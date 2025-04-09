//
//  PlanEventDateViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/09/2024.
//

import Foundation
import UIKit
import SnapKit


class PlanEventDateViewController: BaseViewController {
    
    private let service:Service
    private var body:PlanEventBody
    
    init(service: Service, body:PlanEventBody) {
        self.service = service
        self.body = body
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let back:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Organize event".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Enter event date".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    private lazy var date:UITextField = {
        let textfield = UITextField()
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        textfield.tintColor = .black
        textfield.textColor = .black
        textfield.placeholder = "DD/MM"
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.delegate = self
        return textfield
    }()
    
    
    lazy var proceedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.setActive(true)
        btn.enableDisableSaveButton(isEnable: false)
        return btn
    }()
    
    
    override func setup() {
        view.backgroundColor = .white
        [back , titleLbl , messageLbl , date, proceedBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        back.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.back.snp.centerY)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(65.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        date.snp.makeConstraints { make in
            make.top.equalTo(self.messageLbl.snp.bottom).offset(70.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.centerX.equalToSuperview()
            make.height.equalTo(50.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        proceedBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-53.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        date.becomeFirstResponder()
    }
    
    override func keyboardOpened(with height: CGFloat) {
        proceedBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-height)
        }
    }
    
    
    override func keyboardClosed(with height: CGFloat) {
        proceedBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-53)
        }
    }
    
    
    override func actions() {
        proceedBtn.tap = {
//            if let message = self.validateDateString(self.date.text ?? "") {
//                MainHelper.showToastMessage(message: message, style: .info, position: .Top)
//            }else{
                self.body.eventDate = self.date.text
                let vc = CelebrateBudgetViewController(service: self.service, body: self.body)
                self.navigationController?.pushViewController(vc, animated: true)
           // }
        }
        
        back.tap {self.navigationController?.popViewController(animated: true)}
    }
    


    func validateDateString(_ dateString: String, dateFormat: String = "dd/MM") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let dateStringWithYear = dateString + "/\(currentYear)"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let inputDate = dateFormatter.date(from: dateStringWithYear) else {
            return "Invalid date format. Please use DD/MM."
        }
        
        let calendar = Calendar.current
        
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else {
            return "Failed to calculate tomorrow's date."
        }
        
        let startOfGivenDate = calendar.startOfDay(for: inputDate)
        let startOfTomorrow = calendar.startOfDay(for: tomorrow)
        
        if startOfGivenDate >= startOfTomorrow {
            return nil
        } else {
            return "The date must be equal to or greater than tomorrow."
        }
    }
}
extension PlanEventDateViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            textField.text = formatDate(newText)
            self.proceedBtn.enableDisableSaveButton(isEnable: isValidDate(formatDate(newText)))
            return false
        }

        let allowedCharacters = CharacterSet(charactersIn: "0123456789/")
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }

        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        let formattedText = formatDate(newText)
        textField.text = formattedText
        self.proceedBtn.enableDisableSaveButton(isEnable: isValidDate(formattedText))
        return false
    }

    private func formatDate(_ text: String) -> String {
        var cleanText = text.replacingOccurrences(of: "/", with: "")
        if cleanText.count > 4 {
            cleanText = String(cleanText.prefix(4))
        }
        var formattedText = ""
        if cleanText.count > 2 {
            let day = cleanText.prefix(2)
            let month = cleanText.suffix(from: cleanText.index(cleanText.startIndex, offsetBy: 2))
            formattedText = "\(day)/\(month)"
        } else {
            formattedText = cleanText
        }
        
        return formattedText
    }
    
    func isValidDate(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }
        let formattedString = dateFormatter.string(from: date)
        return formattedString == dateString
    }
    
}
