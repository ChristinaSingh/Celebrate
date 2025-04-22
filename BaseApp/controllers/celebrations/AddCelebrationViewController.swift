//
//  AddCelebrationViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import UIKit
import SnapKit
import Foundation

class AddCelebrationViewController: BaseViewController {
    
    private var bottomViewBottomConstraint: Constraint?
    private var keyboardManager: KeyboardManager?
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    private var selectedDOB: Date?
    var onDismiss: (() -> Void)?

    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Celebration".localized)
        view.backgroundColor = .white
        return view
    }()
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDismiss?()  // Call the closure when dismissed
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
    
    private let nameLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Celebration name".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let nameTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.placeholder = "Enter".localized
        return textfield
    }()
    
    
    private let typeLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Occassion type".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let typeTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.placeholder = "Enter an occassion".localized
        return textfield
    }()
    
    
    private let dateLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Date of event".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let dateTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.rightViewMode = .always
        textfield.textfield.rightView = UIImageView(image: UIImage(named: "calendar"))
        textfield.textfield.isUserInteractionEnabled = false
        textfield.textfield.placeholder = "Select a date".localized
        return textfield
        
    }()
    @objc private func showDatePicker1() {
        
        let vc = SelectAddressViewController(locationId: "", areaName: "")
        vc.callback = { [self] address in
            guard let address = address else {return}
            self.locationTF.text = address.name
            strLocationId = address.name
        }
        vc.isModalInPresentation = true
        self.present(vc, animated: true)

    }
    @objc private func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        let alert = UIAlertController(title: "Select DOB", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(alert.view.snp.top).offset(20)
            make.centerX.equalTo(alert.view)
            make.height.equalTo(150)
        }

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.selectedDOB = datePicker.date
            self.dateTF.text = formatter.string(from: datePicker.date)
            formatter.dateFormat = "yyyy-MM-dd"

            self.strDate = formatter.string(from: datePicker.date)

           // self.dobButton.setTitle("DOB: \(formatter.string(from: datePicker.date))", for: .normal)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    
    private let locationLbl:C8Label = {
        let lbl = C8Label.createMandatoryLabel(withText: "Location".localized, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12), textColor: .black, asteriskColor: .red)
        return lbl
    }()
    
    private let locationTF:C8InputView = {
        let textfield = C8InputView()
        textfield.backgroundColor = .white
        textfield.textfield.rightViewMode = .always
        textfield.textfield.rightView = UIImageView(image: UIImage(named: "collapse_arrow"))
        textfield.textfield.isUserInteractionEnabled = false
        textfield.textfield.placeholder = "Select an address".localized
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
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    var strLocationId:String! = ""
    var strDate:String! = ""

    override func setup() {
        
        doneBtn.tap = { [self] in
            addCelebration(name: nameTF.text!, locationID: strLocationId!, dateTime: strDate!, occasionType: typeTF.text!)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateTF.textfield.addGestureRecognizer(tapGesture)
        dateTF.textfield.isUserInteractionEnabled = true

        let tapGestured = UITapGestureRecognizer(target: self, action: #selector(showDatePicker1))
        locationTF.textfield.addGestureRecognizer(tapGestured)
        locationTF.textfield.isUserInteractionEnabled = true

        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
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
        
        [nameLbl, nameTF, typeLbl, typeTF, dateLbl, dateTF, locationLbl, locationTF].forEach { view in
            self.contentView.addSubview(view)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(18)
        }
        
        
        nameTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.nameLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        typeLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.nameTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        
        typeTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.typeLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        
        dateLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.typeTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        
        dateTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.dateLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
        }
        
        locationLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.dateTF.snp.bottom).offset(24)
            make.height.equalTo(18)
        }
        
        
        locationTF.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.locationLbl.snp.bottom).offset(8)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        keyboardManager = KeyboardManager(viewController: self, bottomConstraint: bottomViewBottomConstraint)
    }
    
    override func keyboardOpened(with height: CGFloat) {
        doneCardView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-height)
            make.height.equalTo(80)
        }
    }
    
    override func keyboardClosed(with height: CGFloat) {
        doneCardView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
    }

    func addCelebration(name: String, locationID: String, dateTime: String, occasionType: String) {
        guard let url = URL(string: "https://celebrate.inchrist.co.in/api/customer/addcelebration") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = User.load()?.token {
            request.setValue(token, forHTTPHeaderField: "x-api-key") // ✅ Custom header
        }

        let body: [String: Any] = [
            "celebration_name": name,
            "location_id": locationID,
            "date_time": dateTime,
            "occassion_type": occasionType
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error:", error)
                return
            }

            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("🎉 Celebration added:", json)
                DispatchQueue.main.async {
                    ToastBanner.shared.show(message: "Add celebration successfully", style: .success, position: .Bottom)
                    self.dismiss(animated: true)
                }

            } catch {
                print("Failed to parse response:", error)
            }
        }.resume()
    }

}
