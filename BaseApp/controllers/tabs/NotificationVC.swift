//
//  NotificationVC.swift
//  BaseApp
//
//  Created by Gajendra on 10/04/25.
//

import UIKit
import SnapKit

class NotificationVC: UIViewController {

    let backButton = UIButton()
    let titleLabel = UILabel()
    let tableView = UITableView()

    var notifications: [(message: String, date: String)] = [
        ("Booking has been Completed successfully.", "2024-12-19 15:49:56"),
        ("You Have a new booking from this Gajendra ", "2024-12-19 16:25:25"),
        ("Booking has been Completed successfully.", "2024-12-19 16:26:43"),
        ("You Have a new booking from this Gajendra ", "2024-12-19 19:08:59"),
        ("Booking has been Completed successfully.", "2024-12-19 19:11:00"),
        ("You Have a new booking from this Gajendra", "2024-12-20 11:13:08"),
        ("Booking has been Completed successfully.", "2024-12-19 19:11:00"),
        ("Booking has been Completed successfully.", "2024-12-19 19:11:00"),
        ("Booking has been Completed successfully.", "2024-12-19 19:11:00"),
        ("Booking has been Completed successfully.", "2024-12-19 19:11:00"),
        ("Booking has been Completed successfully.", "2024-12-19 19:11:00")
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
        backButton.backgroundColor = .clear
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }

        // Title
        titleLabel.text = "Notifiaciton".localized
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

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
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

class NotificationCell: UITableViewCell {

    let iconView = UIImageView()
    let messageLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 0.5
        container.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        contentView.addSubview(container)

        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        iconView.backgroundColor = UIColor.init(named: "AccentColor")
        iconView.layer.cornerRadius = 30
        iconView.clipsToBounds = true
        iconView.image = UIImage.init(named: "avatar_details")
        container.addSubview(iconView)

        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        messageLabel.numberOfLines = 0
        container.addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
        }

        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .gray
        container.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(4)
            make.left.equalTo(messageLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func configure(message: String, date: String) {
        messageLabel.text = message
        dateLabel.text = date
    }
}
