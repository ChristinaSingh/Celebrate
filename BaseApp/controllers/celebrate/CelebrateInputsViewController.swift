//
//  CelebrateInputsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/10/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


protocol InputsDelegate {
    func inputDidChange(_ input:Input, value:String)
}

class CelebrateInputsViewController: BaseViewController, UITextFieldDelegate  {
    
    
    private let delegate:InputsDelegate
    private let input:Input
    private let viewModel:CelebrateViewModel
    private var area:Area?
    private var day:Day?
    private var time:TimeSlot?
    private var occasions:[CelebrateOcassion]
    private var categories:[Category]
    private var inputs:[Input]
    
    
    init(delegate:InputsDelegate, input:Input) {
        self.delegate = delegate
        self.input = input
        self.area = nil
        self.day = nil
        self.time = nil
        self.occasions = []
        self.categories = []
        self.inputs = []
        self.viewModel = CelebrateViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let back:UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    
    let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Celebrate".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    lazy private var messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = AppLanguage.isArabic() ? input.arName : input.name
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    lazy private var inputTF:C8TextField = {
        let textfield = C8TextField()
        textfield.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        textfield.tintColor = .black
        textfield.textColor = .black
        textfield.delegate = self
        textfield.isUserName = false
        textfield.handleBackward = false
        textfield.keyboardType = input.contentType == "number" ? .asciiCapableNumberPad : .default
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
        back.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        back.tintColor = .black
        [back , titleLbl , messageLbl , inputTF, proceedBtn].forEach { view in
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
        
        inputTF.snp.makeConstraints { make in
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
        inputTF.becomeFirstResponder()
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
    
    
    override func observers() {
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.proceedBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$prices.receive(on: DispatchQueue.main).sink { prices in
            if let prices {
                let allSubcategoryIDs = self.categories
                    .flatMap { $0.subcategories }
                    .filter { $0.isSelected }
                    .compactMap { $0.id }
                    .map { "\($0)" }
                    .joined(separator: ",")
                let vc = CelebrateBudgetViewController(area: self.area, day: self.day, time: self.time, occasions: self.occasions, categories: self.categories, subcategories: allSubcategoryIDs, inputs: self.inputs, prices: prices)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
    }
    
    
    override func actions() {
        proceedBtn.tap = {
            self.delegate.inputDidChange(self.input, value: self.inputTF.text ?? "")
        }
        
        back.tap {self.navigationController?.popViewController(animated: true)}
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let disallowedCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:',.<>?/~`")
        if let _ = string.rangeOfCharacter(from: disallowedCharacterSet) {
            return false
        }
        let englishCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        let isEnglish = string.rangeOfCharacter(from: englishCharacterSet.inverted) == nil
        proceedBtn.enableDisableSaveButton(isEnable: updatedText.trimmingCharacters(in: .whitespaces).count >= 2)
        return isEnglish
    }
    
    
    func proceed(inputs:[Input], subcategories:String, area: Area?, day: Day?, time: TimeSlot?, occasions: [CelebrateOcassion], categories: [Category]) {
        self.inputs = inputs
        self.area = area
        self.day = day
        self.time = time
        self.occasions = occasions
        self.categories = categories
        self.viewModel.getPrices(subCategories: subcategories)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cancellables.forEach{ $0.cancel() }
    }
    
    
}
