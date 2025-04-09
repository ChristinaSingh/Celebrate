//
//  AddAddressViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import UIKit
import SnapKit
import Combine
import IQKeyboardManagerSwift

class AddAddressViewController: BaseViewController, AreaSelectionDelegate {

    private var bottomViewBottomConstraint: Constraint?
    let viewModel = AddressesViewModel()
    var locationId:String? = nil
    var areaName:String? = nil
    private var keyboardManager: KeyboardManager?
    var body:AddressBody = AddressBody(){
        didSet{
            self.saveBtn.enableDisableSaveButton(isEnable: body.isValid())
        }
    }
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Address details".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let hintView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 0.1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    
    private let hintLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        lbl.numberOfLines = 2
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.text = "A detailed address will help our delivery partner reach your doorstep easily".localized
        return lbl
    }()
    
    
    
    private let addressLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .black
        lbl.text = "Address label".localized
        return lbl
    }()
    
    let addressLabelTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        return textfield
    }()
    
    
    private let addressTypeLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Address type".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    let addressTypeView:AddressTypeView = {
        let view = AddressTypeView()
        return view
    }()
    
    
    private let areaLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Area".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    
    
    let areaTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.keyboardType = .asciiCapableNumberPad
        return textfield
    }()
    
    private let blockLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Block".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    let blocklTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.keyboardType = .asciiCapableNumberPad
        return textfield
    }()
    
    
    private let streetLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Street".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    let streetlTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        return textfield
    }()
    
    
    
    let floorLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Floor".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    let floorTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.keyboardType = .asciiCapableNumberPad
        return textfield
    }()
    
    var apartmentLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Appartment".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    let apartmentTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.keyboardType = .asciiCapableNumberPad
        return textfield
    }()
    
    
    lazy var appartmentStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [apartmentLbl, apartmentTF])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    
    lazy var floorStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [floorLbl, floorTF])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    
    lazy var buildingFloorStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [floorStack, appartmentStack])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    var houseLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "House no.".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    let houseTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        return textfield
    }()
    
    let phoneLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Mobile number".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    let phoneTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.isPhone = true
        return textfield
    }()
    
    private let directionsLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .black
        lbl.text = "Directions to reach (optional)".localized
        return lbl
    }()
    
    lazy var directionsTV:PaddedTextView = {
        let textview = PaddedTextView()
        textview.layer.cornerRadius = 8
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        textview.clipsToBounds = true
        textview.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        textview.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        textview.textAlignment = AppLanguage.isArabic() ? .right : .left
        return textview
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
    
    
    
    lazy var saveBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Save address details".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    lazy var fields:[UIResponder] = [addressLabelTF.textfield, blocklTF.textfield, streetlTF.textfield, houseTF.textfield, phoneTF.textfield, directionsTV]{
        didSet{
            KeyboardToolbar.shared.setup(fields: fields, parentView: self.view)
        }
    }
    var addressDidAdd:((Address) -> ())?
    
    override func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        KeyboardToolbar.shared.setup(fields: fields, parentView: self.view)
        self.body.locationID = self.locationId
        self.body.area = self.areaName
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
        
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom).inset(101)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        [hintView , addressLbl , addressLabelTF, areaLbl, areaTF ,addressTypeLbl, addressTypeView, blockLbl, blocklTF, streetLbl, streetlTF, houseLbl, houseTF, buildingFloorStack, phoneLbl, phoneTF, directionsLbl, directionsTV].forEach { view in
            self.contentView.addSubview(view)
        }
        
        
        hintView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(24)
        }
        
        hintView.addSubview(hintLbl)
        hintLbl.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        addressLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.hintView.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        addressLabelTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.addressLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        areaLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(self.locationId == nil ? 18 : 0)
            make.top.equalTo(self.addressLabelTF.snp.bottom).offset(self.locationId == nil ? 24 : 0)
        }

        areaTF.textfield.inputView = UIView()
        areaTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.areaLbl.snp.bottom).offset(self.locationId == nil ? 8 : 0)
            make.height.equalTo(self.locationId == nil ? 48 : 0)
        }
        
        addressTypeLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(self.areaTF.snp.bottom).offset(24)
        }
        
        addressTypeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.addressTypeLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        blockLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(self.addressTypeView.snp.bottom).offset(24)
        }
        
        blocklTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.blockLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        streetLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(self.blocklTF.snp.bottom).offset(24)
        }
        
        streetlTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.streetLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        houseLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(self.streetlTF.snp.bottom).offset(24)
        }
        
        houseTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.houseLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        buildingFloorStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.houseTF.snp.bottom).offset(0)
            make.height.equalTo(0)
        }
        
        
        floorTF.snp.makeConstraints { make in
            make.width.equalTo((self.view.frame.width - 48) / 2)
            make.height.equalTo(0)
        }
        
        
        apartmentTF.snp.makeConstraints { make in
            make.width.equalTo((self.view.frame.width - 48) / 2)
            make.height.equalTo(0)
        }
        
        phoneLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(self.buildingFloorStack.snp.bottom).offset(24)
        }
        

        phoneTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.phoneLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        directionsLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(self.phoneTF.snp.bottom).offset(24)
        }
        
        directionsTV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.directionsLbl.snp.bottom).offset(8)
            make.height.equalTo(95)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        keyboardManager = KeyboardManager(viewController: self, bottomConstraint: bottomViewBottomConstraint)
        addressTypeView.typeDidChanged = {
            self.body.type = self.addressTypeView.type?.rawValue
            if self.addressTypeView.type == .house {
                self.fields = [self.addressLabelTF.textfield, self.blocklTF.textfield, self.streetlTF.textfield, self.houseTF.textfield, self.phoneTF.textfield, self.directionsTV]
                self.buildingFloorStack.snp.updateConstraints { make in
                    make.top.equalTo(self.houseTF.snp.bottom).offset(0)
                    make.height.equalTo(0)
                }
                
                self.apartmentTF.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                
                self.floorTF.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.saveBtn.enableDisableSaveButton(isEnable: self.body.isValid())
                self.houseLbl = C8Label.createMandatoryLabel(withText: "House no.".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
            }else{
                self.fields = [self.addressLabelTF.textfield, self.blocklTF.textfield, self.streetlTF.textfield, self.houseTF.textfield, self.floorTF.textfield, self.apartmentTF.textfield , self.phoneTF.textfield, self.directionsTV]
                self.buildingFloorStack.snp.updateConstraints { make in
                    make.top.equalTo(self.houseTF.snp.bottom).offset(24)
                    make.height.equalTo(74)
                }
                
                self.apartmentTF.snp.updateConstraints { make in
                    make.height.equalTo(48)
                }
                
                self.floorTF.snp.updateConstraints { make in
                    make.height.equalTo(48)
                }
                
                if self.floorTF.textfield.text?.isEmpty ?? true || self.apartmentTF.textfield.text?.isEmpty ?? true{
                    self.saveBtn.enableDisableSaveButton(isEnable: false)
                }else{
                    self.saveBtn.enableDisableSaveButton(isEnable: self.body.isValid())
                }
            
                if self.addressTypeView.type == .office {
                    self.apartmentLbl.attributedText = C8Label.createAttributedText(withText: "office no".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
                }else{
                    self.apartmentLbl.attributedText = C8Label.createAttributedText(withText: "Appartment".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
                }
                self.houseLbl.attributedText = C8Label.createAttributedText(withText: "building no".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
            }
        }
        areaTF.textfield.addTarget(self, action: #selector(showAreasList), for: .editingDidBegin)
        addressLabelTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addressLabelTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        blocklTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        blocklTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        streetlTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        streetlTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        houseTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        houseTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        phoneTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        phoneTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        floorTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        floorTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
        apartmentTF.textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        apartmentTF.textfield.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if textField == addressLabelTF.textfield {
            self.body.name = text
        }else if textField == blocklTF.textfield {
            self.body.block = text
        }else if textField == streetlTF.textfield{
            self.body.street = text
        }else if textField == houseTF.textfield {
            self.body.building = text
        }else if textField == floorTF.textfield {
            self.body.floor = text
        }else if textField == apartmentTF.textfield {
            self.body.suitNo = text
        }else if textField == phoneTF.textfield {
            self.body.alternateNumber = text
        }
        
    }
    
    @objc func beginEditing(_ textField: UITextField) {
        KeyboardToolbar.shared.updateActiveField(textField)
    }
    
    @objc func showAreasList() {
        self.areaTF.textfield.resignFirstResponder()
        AreasViewController.show(on: self, delegate: self)
    }
    
    
    override func actions() {
        self.saveBtn.tap = {
            self.body.additionalinfo = self.directionsTV.text
            self.viewModel.addAddress(address: self.body)
        }
    }
    
    
    override func observers() {
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.viewModel.$addressAdded.receive(on: DispatchQueue.main).sink { address in
            guard let address = address else {return}
            ToastBanner.shared.show(message: "Address added successfully", style: .success, position: .Bottom)
            self.dismiss(animated: true) {
                self.addressDidAdd?(address)
            }
        }.store(in: &cancellables)
    }
    
    func areaDidSelected(area: Area?) {
        self.body.area = AppLanguage.isArabic() ? area?.arName : area?.name
        self.areaTF.text = AppLanguage.isArabic() ? area?.arName : area?.name
        self.locationId = area?.id
        self.body.locationID = area?.id
    }
    
  
}

