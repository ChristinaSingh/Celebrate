//
//  MyCelebrationVC.swift
//  BaseApp
//
//  Created by Gajendra on 12/04/25.
//

import UIKit
import SnapKit

class MyCelebrationVC: UIViewController {
    
    let backButton = UIButton()
    let titleLabel = UILabel()
    let tableView = UITableView()
    let plusButton = UIButton()

    var notifications: [(message: String, date: String)] = [
       
        ("Name - Gajedra Thakur", "DOB - 28-08-2000"),
        ("Name - Arav Thakur", "DOB - 11-08-2000"),
        ("Name - Satwik Thakur", "DOB - 12-08-2000"),
        ("Name - Dommin Thakur", "DOB - 23-08-2000"),
        ("Name - Parthiv Thakur", "DOB - 11-08-2000"),
        ("Name - Gajedra Thakur", "DOB - 02-08-2000"),
        ("Name - Gajedra Thakur", "DOB - 05-08-2000")

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
    }

    private func setupNavBar() {
        // Back button
        backButton.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        plusButton.setImage(UIImage.init(named: "plus"), for: .normal)

        backButton.backgroundColor = .clear
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)

        plusButton.backgroundColor = .clear
        plusButton.tintColor = .black
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        view.addSubview(plusButton)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }

        // Title
        titleLabel.text = "My Celebration".localized
        titleLabel.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
    }
    @objc private func plusTapped() {
        let vc = AddMyCelebVC()
        vc.isModalInPresentation = true
        self.present(vc, animated: true)

    }
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
extension MyCelebrationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        let notification = notifications[indexPath.row]
        cell.configure(message: notification.message, date: notification.date)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

