//
//  EditAddressViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/05/2024.
//

import UIKit

class EditAddressViewController: AddAddressViewController {
    
    private var address:Address{
        didSet {
            self.saveBtn.enableDisableSaveButton(isEnable: address.isValid())
        }
    }
    init(address: Address) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setup() {
        super.setup()
        self.locationId = address.location?.locationID
        self.areaTF.text = address.area
        self.floorTF.text = address.floor
        self.apartmentTF.text = address.suitNo
        self.addressLabelTF.text = address.name
        self.addressTypeView.type = address.type
        self.blocklTF.text = address.block
        self.streetlTF.text = address.street
        self.houseTF.text = address.building
        self.phoneTF.text = address.alternateNumber
        self.directionsTV.text = address.additionalinfo
        if address.type == .apartment || address.type == .office{
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
            if self.addressTypeView.type == .office {
                self.apartmentLbl.attributedText = C8Label.createAttributedText(withText: "office no".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
            }else{
                self.apartmentLbl.attributedText = C8Label.createAttributedText(withText: "Appartment".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
            }
            self.houseLbl.attributedText = C8Label.createAttributedText(withText: "building no".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        }else{
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
            self.houseLbl = C8Label.createMandatoryLabel(withText: "House no.".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        }
        self.addressTypeView.typeDidChanged = {
            self.address.type = self.addressTypeView.type
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
        self.saveBtn.enableDisableSaveButton(isEnable: true)
    }
    
    override func actions() {
        self.saveBtn.tap = {
            self.address.additionalinfo = self.directionsTV.text
            self.viewModel.editAddress(address: self.address)
        }
    }
    
    
    override func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if textField == addressLabelTF.textfield {
            self.address.name = text
        }else if textField == blocklTF.textfield {
            self.address.block = text
        }else if textField == streetlTF.textfield{
            self.address.street = text
        }else if textField == houseTF.textfield {
            self.address.building = text
        }else if textField == floorTF.textfield {
            self.address.floor = text
        }else if textField == apartmentTF.textfield {
            self.address.suitNo = text
        }else if textField == phoneTF.textfield {
            self.address.alternateNumber = text
        }
    }
    
    
    override func observers() {
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        self.viewModel.$addressEdited.receive(on: DispatchQueue.main).sink { address in
            guard let address = address else {return}
            ToastBanner.shared.show(message: "Address updated successfully", style: .success, position: .Bottom)
            self.dismiss(animated: true) {
                self.addressDidAdd?(address)
            }
        }.store(in: &cancellables)
    }

}
