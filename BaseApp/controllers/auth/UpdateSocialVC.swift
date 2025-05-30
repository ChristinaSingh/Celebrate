//
//  UpdateSocialVC.swift
//  BaseApp
//
//  Created by Gajendra on 07/04/25.
//

import UIKit
import SnapKit
import Combine

class UpdateSocialVC: BaseViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var bottomViewBottomConstraint: Constraint?
    private var keyboardManager: KeyboardManager?
    private let viewModel: ProfileViewModel = ProfileViewModel()
    private let datePicker = UIPickerView()
    private let days = Array(1...31)
    private let months = Calendar.current.monthSymbols

    private var birthDay: String = ""
    private var isValidUsername: Bool = false
    var imageUrl: String = ""
    var Name: String = ""
    var Username: String = ""
    var email: String = ""
    let service:Service

    init(service: Service ) {
        self.service = .Login
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - New Card and Toggle UI Properties
    
    public let preferenceCardView: CardView = {
        let card = CardView()
        card.backgroundColor = .white
        card.cornerRadius = 20
        card.clipsToBounds = true
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        return card
    }()
    
    // MARK: - Existing UI Properties
    
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()

    private let containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let headerView: HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Update details".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let profileImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private let editBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Update".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    private let usernameLbl: C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Username".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .white, asteriskColor: .red)
        return lbl
    }()
    
    private let nameLbl: C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Name".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .white, asteriskColor: .red)
        return lbl
    }()
    
    private let dateOfBirthLbl: C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Date of birth".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .white, asteriskColor: .red)
        return lbl
    }()
    
    lazy private var usernameTF: C8TextField = {
        let username = C8TextField()
        username.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        username.text = "@"
        username.userNameDelegate = self
        username.textColor = .black
        username.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        username.backgroundColor = .white
        username.layer.cornerRadius = 8
        username.layer.borderWidth = 1
        username.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return username
    }()
    
    lazy private var nameTF: C8TextField = {
        let username = C8TextField()
        username.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        username.delegate = self
        username.isUserName = false
        username.textColor = .black
        username.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        username.backgroundColor = .white
        username.layer.cornerRadius = 8
        username.layer.borderWidth = 1
        username.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return username
    }()
    
    lazy private var dateOfBirthTF: C8TextField = {
        let username = C8TextField()
        username.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        username.delegate = nil
        username.isUserName = false
        username.textColor = .black
        username.addBrithDayIcon()
        username.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 16)
        username.backgroundColor = .white
        username.layer.cornerRadius = 8
        username.layer.borderWidth = 1
        username.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        return username
    }()
    
    private let saveCardView: CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    private lazy var saveBtn: LoadingButton = {
        let btn = LoadingButton.createObject(title: "Update".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
  
    @objc func handleGoogleSignIn() {
      
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)

        
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true)
        }
    }

    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
        }
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        updateProfileTriggered()
        
        editBtn.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        headerView.cancel(vc: self)
        [headerView, scrollView, saveCardView].forEach { view in
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
            make.bottom.equalToSuperview()
        }
        
        // Existing content views added to contentView
        [profileImg, editBtn, usernameLbl, usernameTF, nameLbl, nameTF, dateOfBirthLbl, dateOfBirthTF].forEach { view in
            self.contentView.addSubview(view)
        }
        
        profileImg.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
        }
        
        editBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileImg.snp.centerY)
            make.leading.equalTo(self.profileImg.snp.trailing).offset(16)
        }
        
        usernameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.profileImg.snp.bottom).offset(25)
            make.height.equalTo(18)
        }
        
        usernameTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.usernameLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.usernameTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        nameTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.nameLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        dateOfBirthLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.nameTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        dateOfBirthTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.dateOfBirthLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        // MARK: - Preference Card Setup
        // Add the white card that wraps the toggle options
        self.contentView.addSubview(preferenceCardView)
        preferenceCardView.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthTF.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-34)
        }
        
        // Setup date picker for Date of Birth field
        datePicker.delegate = self
        datePicker.dataSource = self
        dateOfBirthTF.inputView = datePicker
        dateOfBirthTF.addTarget(self, action: #selector(dateChanged), for: .editingDidEnd)
        
        saveBtn.tap = {
           // self.navigationController?.popViewController(animated: true)
            // self.updateProfile()
//            self.navigationController?.pushViewController(AuthWelcomeViewController(service: Service(rawValue: "none")!), animated: true)
            self.navigationController?.pushViewController(AuthWelcomeViewController(service: self.service), animated: true)

        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            self.saveBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        viewModel.$updatedUser.receive(on: DispatchQueue.main).sink { updatedUser in
            if let user = User.load(), let updatedUser = updatedUser {
                user.details = updatedUser.details
                user.save()
                MainHelper.showToastMessage(message: "Profile updated successfully".localized, style: .success, position: .Bottom)
                self.dismiss(animated: true)
            }
        }.store(in: &cancellables)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileTriggered), name: Notification.Name("user.updated"), object: nil)
        viewModel.$error.receive(on: DispatchQueue.main).sink { error in
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        if let user = User.load()?.details {
            self.usernameTF.text = "@\(user.username ?? "")"
            self.nameTF.text = user.fullName
            self.isValidUsername = !(user.username ?? "").isEmpty
            if let birthday = user.birthday, !birthday.isEmpty {
                self.birthDay = birthday
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.locale = AppLanguage.isArabic() ? Locale(identifier: "ar") : Locale(identifier: "en")
                dateFormatter.dateFormat = "ddMM"
                if let birthDate = dateFormatter.date(from: birthday) {
                    dateFormatter.dateFormat = "dd MMM"
                    dateOfBirthTF.text = dateFormatter.string(from: birthDate)
                }
            }
           self.enableDisableSaveButton()
        }
        
//        profileImg.download(imagePath: profileImg, size: CGSize(width: 81, height: 81), placeholder: UIImage(named: "avatar_details"))

    }
    
    @objc func updateProfileTriggered() {
        profileImg.download(imagePath: imageUrl, size: CGSize(width: 81, height: 81), placeholder: UIImage(named: "avatar_details"))
        usernameTF.text = Username
        nameTF.text = email

//        profileImg.download(imagePath: User.load()?.details?.avatar?.imageURL ?? "", size: CGSize(width: 81, height: 81), placeholder: UIImage(named: "avatar_details"))
    }
    
    @objc func dateChanged() {
        let selectedDay = days[datePicker.selectedRow(inComponent: 0)]
        let selectedMonth = months[datePicker.selectedRow(inComponent: 1)]
        let formattedDay = String(format: "%02d", selectedDay)
        let string = String(format: "%02d%02d", selectedDay, datePicker.selectedRow(inComponent: 1) + 1)
        self.birthDay = string
        dateOfBirthTF.text = "\(formattedDay)-\(selectedMonth.prefix(3))"
        self.enableDisableSaveButton()
    }
    
    private func updateProfile() {
        let username = usernameTF.text
        let name = nameTF.text
        let user = User.load()?.details
        viewModel.updateProfile(name: name, email: user?.email, mobile: user?.mobileNumber, birthday: self.birthDay, username: username?.replacingOccurrences(of: "@", with: ""), ispublic: user?.ispublic)
    }
    
    // MARK: - Toggle Actions
    
    @objc private func publicProfileSwitchChanged(_ sender: UISwitch) {
        let newValue = sender.isOn ? "1" : "0"
        if let user = User.load(), let details = user.details {
            // Update the profile's public status
            viewModel.updateProfile(name: details.fullName, email: details.email, mobile: details.mobileNumber, birthday: details.birthday, username: details.username, ispublic: newValue)
        }
    }
    
    @objc private func allowFriendsSwitchChanged(_ sender: UISwitch) {
        // Handle the "Allow friends to plan events" toggle change.
        print("Allow friends to plan events toggled: \(sender.isOn)")
    }
    
    override func keyboardOpened(with height: CGFloat) {
        bottomViewBottomConstraint?.update(offset: -height + view.safeAreaInsets.bottom)
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height + 90, right: 0)
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardClosed(with height: CGFloat) {
        bottomViewBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
            self.view.layoutIfNeeded()
        }
    }
}

extension UpdateSocialVC: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return days.count
        } else {
            return months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(format: "%02d", days[row])
        } else {
            return months[row]
        }
    }
    
    private func isValidForm() -> Bool {
        return isValidUsername && self.nameTF.text?.isEmpty == false && self.birthDay.isEmpty == false
    }
    
    private func enableDisableSaveButton() {
       // saveBtn.enableDisableSaveButton(isEnable: isValidForm())
    }
}

extension UpdateSocialVC: UsernameTextFieldDelegate {
    func username(_ isValid: Bool) {
        self.usernameTF.isValidUserName = isValid && ExcludedUserNamesManager.shared.isUserNameAcceptted(username: self.usernameTF.text ?? "")
        self.isValidUsername = isValid
        self.enableDisableSaveButton()
    }
}

extension UpdateSocialVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.enableDisableSaveButton()
        let englishCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        let isEnglish = string.rangeOfCharacter(from: englishCharacterSet.inverted) == nil
        return isEnglish
    }
}

