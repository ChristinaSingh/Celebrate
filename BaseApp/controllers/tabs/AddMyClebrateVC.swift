//
//  AddMyClebrateVC.swift
//  BaseApp
//
//  Created by Gajendra on 12/04/25.
//

import UIKit
import SnapKit

class AddMyClebrateVC: UIViewController {

    private let profileImageView = UIImageView()
    private let nameTextField = UITextField()
    private let dobButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)
    
    private var selectedDOB: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        // Profile image
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        // Name text field
        nameTextField.placeholder = "Enter Name"
        nameTextField.borderStyle = .roundedRect
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        // DOB picker button
        dobButton.setTitle("Select DOB", for: .normal)
        dobButton.setTitleColor(.systemBlue, for: .normal)
        dobButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        view.addSubview(dobButton)
        dobButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // Submit button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(dobButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions

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
            self.dobButton.setTitle("DOB: \(formatter.string(from: datePicker.date))", for: .normal)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    @objc private func handleSubmit() {
        guard let name = nameTextField.text, !name.isEmpty,
              let dob = selectedDOB else {
            showAlert("Please fill all fields.")
            return
        }

        // Use name, dob, profileImageView.image
        print("Name: \(name), DOB: \(dob)")
        showAlert("Data Submitted 🎉")
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

extension AddMyClebrateVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
    }
}
