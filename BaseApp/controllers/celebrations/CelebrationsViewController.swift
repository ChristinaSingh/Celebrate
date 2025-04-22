//
//  CelebrationsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit

class CelebrationsViewController: UIViewController {
    
    private let emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "emptycelebrations"), message: "Looks like you don’t have any celebrations".localized, imgSize: CGSize(width: 120, height: 120))
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    var celebrations: [Celebration] = []

    lazy private var tableView:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(CelebrationCell.self, forCellReuseIdentifier: "CelebrationCell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        return table
    }()
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Celebrations".localized)
        view.backgroundColor = .white
        return view
    }()
    
    private let addCelebrationsCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    private lazy var addCelebrationsBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Add a celebration".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        emptyState.message = "Looks like you don’t have any celebrations".localized
        emptyState.icon = UIImage(named: "emptycelebrations")
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.back(vc: self)
        [headerView, emptyState, tableView, addCelebrationsCardView].forEach { view in
            self.containerView.addSubview(view)
        }
        self.addCelebrationsCardView.addSubview(addCelebrationsBtn)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        addCelebrationsBtn.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        emptyState.isHidden = true
        emptyState.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(145)
            make.height.equalTo(180)
        }
        
        addCelebrationsCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.addCelebrationsCardView.snp.top)
        }
        
        addCelebrationsBtn.tap = {
            let vc = AddCelebrationViewController()
            vc.isModalInPresentation = true
            vc.onDismiss = { [weak self] in
                self?.fetchCelebrationList { [weak self] list in
                    self?.celebrations = list
                    self?.tableView.reloadData()
                }
            }

            self.present(vc, animated: true)
        }
        fetchCelebrationList { [weak self] list in
            self?.celebrations = list
            self?.tableView.reloadData()
        }

    }
    
    func fetchCelebrationList(completion: @escaping ([Celebration]) -> Void) {
        guard let url = URL(string: "https://celebrate.inchrist.co.in/api/customer/celebrationlist") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = User.load()?.token {
            request.setValue(token, forHTTPHeaderField: "x-api-key") // ✅ Custom header
            print("tokentoken \(token)")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error:", error)
                return
            }

            guard let data = data else { return }
            print("API Error:", data)

            do {
                let result = try JSONDecoder().decode(CelebrationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.data)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

}
extension CelebrationsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrationCell") as! CelebrationCell
        let celebration = celebrations[indexPath.row]
        cell.titleLbl.text = "\(celebration.celebration_name)"
        cell.addressLbl.text = "\(celebration.occassion_type)"
        let formatted = formatDate("\(celebration.date_time)")
        let result = timeRemaining(from: celebration.date_time)

        cell.monthDayLbl.text = formatted
        cell.dateLbl.text = result

        return cell
    }
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM" // Example: 19 April
            return outputFormatter.string(from: date)
        }
        return ""
    }
    func timeRemaining(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let futureDate = dateFormatter.date(from: dateString) else { return "Invalid date" }

        let calendar = Calendar.current
        let now = Date()

        if futureDate < now {
            return "Date has passed"
        }

        let components = calendar.dateComponents([.year, .month, .day], from: now, to: futureDate)

        var parts: [String] = []

        if let year = components.year, year > 0 {
            parts.append("\(year) year\(year > 1 ? "s" : "")")
        }
        if let month = components.month, month > 0 {
            parts.append("\(month) month\(month > 1 ? "s" : "")")
        }
        if let day = components.day, day > 0 {
            parts.append("\(day) day\(day > 1 ? "s" : "")")
        }

        return parts.isEmpty ? "Today" : parts.joined(separator: ", ") + " left"
    }


}
