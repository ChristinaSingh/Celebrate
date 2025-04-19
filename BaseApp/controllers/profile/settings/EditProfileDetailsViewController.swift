//
//  EditProfileDetailsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 19/05/2024.
//

import UIKit
import SnapKit
import Combine

class EditProfileDetailsViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var bottomViewBottomConstraint: Constraint?
    private var keyboardManager: KeyboardManager?
    private let viewModel: ProfileViewModel = ProfileViewModel()
    private let datePicker = UIPickerView()
    private let days = Array(1...31)
    private let months = Calendar.current.monthSymbols
    private var birthDay: String = ""
    private var isValidUsername: Bool = false
    
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
    
    private let preferenceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preference".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
        label.textColor = .black
        return label
    }()
    
    private let makeProfilePublicLabel: UILabel = {
        let label = UILabel()
        label.text = "Make profile public".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = .black
        return label
    }()
    
    private let makeProfilePublicSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = User.load()?.details?.ispublic != "0"
        return toggle
    }()
    
    private let allowFriendsToPlanEventsLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow friends to plan events".localized
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        label.textColor = .black
        return label
    }()
    
    private let allowFriendsToPlanEventsSwitch: UISwitch = {
        let toggle = UISwitch()
        // Set default value as needed or load from user preferences.
        toggle.isOn = false
        return toggle
    }()
    
    // MARK: - Existing UI Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    let headerView: HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Edit personal details".localized)
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
        btn.setTitle("Edit".localized, for: .normal)
        btn.setTitleColor(.accent, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 14)
        return btn
    }()
    
    private let usernameLbl: C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Username".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let nameLbl: C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Name".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let dateOfBirthLbl: C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Date of birth".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
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
        let btn = LoadingButton.createObject(title: "Save".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
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

        // Add subviews to the preferenceCardView
        [preferenceTitleLabel, makeProfilePublicLabel, makeProfilePublicSwitch, allowFriendsToPlanEventsLabel, allowFriendsToPlanEventsSwitch].forEach { view in
            self.preferenceCardView.addSubview(view)
        }

        // Preference Title Label
        preferenceTitleLabel.snp.makeConstraints { make in
            // Change 25 to adjust the top spacing within the card
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        // First option: Make Profile Public
        makeProfilePublicLabel.snp.makeConstraints { make in
            // Change 25 to adjust vertical space between the title and first option
            make.top.equalTo(preferenceTitleLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(16)
        }
        makeProfilePublicSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(makeProfilePublicLabel)
            make.trailing.equalToSuperview().offset(-16)
        }

        // Second option: Allow Friends to Plan Events
        allowFriendsToPlanEventsLabel.snp.makeConstraints { make in
            // Change 25 to adjust vertical space between the first and second option
            make.top.equalTo(makeProfilePublicLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(16)
        }
        allowFriendsToPlanEventsSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(allowFriendsToPlanEventsLabel)
            make.trailing.equalToSuperview().offset(-16)
            // Change 25 to adjust the bottom spacing of the card
            make.bottom.equalToSuperview().offset(-25)
        }
        
        // Add target actions for the toggles
        makeProfilePublicSwitch.addTarget(self, action: #selector(publicProfileSwitchChanged(_:)), for: .valueChanged)
        allowFriendsToPlanEventsSwitch.addTarget(self, action: #selector(allowFriendsSwitchChanged(_:)), for: .valueChanged)
        
        // Setup date picker for Date of Birth field
        datePicker.delegate = self
        datePicker.dataSource = self
        dateOfBirthTF.inputView = datePicker
        dateOfBirthTF.addTarget(self, action: #selector(dateChanged), for: .editingDidEnd)
        
        saveBtn.tap = {
            self.updateProfile()
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
    }
    
    @objc func updateProfileTriggered() {
        profileImg.download(imagePath: User.load()?.details?.avatar?.imageURL ?? "", size: CGSize(width: 81, height: 81), placeholder: UIImage(named: "avatar_details"))
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
//        registerUser(
//            name: name,
//            mobile: user?.mobileNumber,
//            phone: "33333333",
//            password: "123123",
//            email: user?.email,
//            address: nil,
//            image: UIImage(named: "your_image")!
//        ) { success, message in
//            print(success ? "✅ Success: \(message)" : "❌ Failed: \(message)")
//        }

    }
    func registerUser(
        name: String,
        mobile: String,
        phone: String,
        password: String,
        email: String,
        address: String?,
        image: UIImage,
        completion: @escaping (Bool, String) -> Void
    ) {
        let url = URL(string: "https://celebrate.inchrist.co.in/api/customer/register")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("0693d647f0fd9b824b1a8c8876853bf4", forHTTPHeaderField: "x-api-key")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()

        func appendFormField(name: String, value: String) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }

        appendFormField(name: "name", value: name)
        appendFormField(name: "mobile", value: mobile)
        appendFormField(name: "phone", value: phone)
        appendFormField(name: "password", value: password)
        appendFormField(name: "email", value: email)
        appendFormField(name: "address", value: address ?? "")

        // Image
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }

        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data

        // API Call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            if let responseStr = String(data: data, encoding: .utf8) {
                print("API Response: \(responseStr)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["status"] as? String,
                   let message = json["message"] as? String {
                    completion(status == "success", message)
                } else {
                    completion(false, "Unexpected response")
                }
            } catch {
                completion(false, "JSON parse error")
            }
        }.resume()
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

extension EditProfileDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
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
        saveBtn.enableDisableSaveButton(isEnable: isValidForm())
    }
}

extension EditProfileDetailsViewController: UsernameTextFieldDelegate {
    func username(_ isValid: Bool) {
        self.usernameTF.isValidUserName = isValid && ExcludedUserNamesManager.shared.isUserNameAcceptted(username: self.usernameTF.text ?? "")
        self.isValidUsername = isValid
        self.enableDisableSaveButton()
    }
}

extension EditProfileDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.enableDisableSaveButton()
        let englishCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        let isEnglish = string.rangeOfCharacter(from: englishCharacterSet.inverted) == nil
        return isEnglish
    }
}
