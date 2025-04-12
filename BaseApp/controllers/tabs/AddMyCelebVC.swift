//
//  AddMyCelebVC.swift
//  BaseApp
//
//  Created by Gajendra on 12/04/25.
//

import UIKit
import SnapKit

class AddMyCelebVC:BaseViewController {
    
    private var bottomViewBottomConstraint: Constraint?
//    private var keyboardManager: KeyboardManager?
    private let profileImageView = UIImageView()
    private var selectedDOB: Date?

    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Add My Celebration".localized)
        view.backgroundColor = .white
        return view
    }()
    
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
    
    private let nameLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Name".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let nameTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.isUserInteractionEnabled = true
        return textfield
    }()
    
        
    
    private let dateLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Date of Birth".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let dateTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.rightViewMode = .always
        textfield.textfield.rightView = UIImageView(image: UIImage(named: "calendar"))
        textfield.textfield.isUserInteractionEnabled = true
        textfield.textfield.placeholder = "Select a date".localized
        return textfield
    }()
    
    
    
    private let doneCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    lazy var doneBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Done".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()

    @objc private func selectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        let alert = UIAlertController(title: "Select DOB", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(alert.view.snp.top).offset(50)
            make.centerX.equalTo(alert.view)
            make.height.equalTo(150)
        }

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.selectedDOB = datePicker.date
           // self.dobButton.setTitle("DOB: \(formatter.string(from: datePicker.date))", for: .normal)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    override func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        
        // Profile image
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)

        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView , scrollView, doneCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        doneCardView.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        doneCardView.snp.makeConstraints { make in
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
        
        [profileImageView,nameLbl, nameTF, dateLbl, dateTF].forEach { view in
            self.contentView.addSubview(view)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }

        nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.profileImageView.snp.bottom).offset(16)
            make.height.equalTo(18)
        }
        
        
        nameTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.nameLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        
        
        dateLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.nameTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        
        dateTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.dateLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        
//        keyboardManager = KeyboardManager(viewController: self, bottomConstraint: bottomViewBottomConstraint)
    }
    
//    override func keyboardOpened(with height: CGFloat) {
//        doneCardView.snp.updateConstraints { make in
//            make.bottom.equalToSuperview().offset(-height)
//            make.height.equalTo(80)
//        }
//    }
//    
//    override func keyboardClosed(with height: CGFloat) {
//        doneCardView.snp.updateConstraints { make in
//            make.bottom.equalToSuperview()
//            make.height.equalTo(101)
//        }
//    }
}
extension AddMyCelebVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
    }
}
