//
//  FriendsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import UIKit
import SnapKit
import Combine

class FriendsViewController: UIViewController {
    
    private let viewModel = FriendsViewModel()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var friends: Friends?
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "FriendsShimmerView")
        return view
    }()
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        lbl.text = "Friends".localized
        return lbl
    }()
    
    private let tabContainer = UIView()
    private let suggestionsButton = UIButton(type: .system)
    private let friendsButton = UIButton(type: .system)
    private let underlineView = UIView()

    private let searchView:CardView = {
        let card = CardView()
        card.backgroundColor = .white
        card.cornerRadius = 28.constraintMultiplierTargetValue.relativeToIphone8Height()
        card.shadowOffsetHeight = 0
        card.shadowOffsetWidth = 0
        card.shadowColor = .clear
        card.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        card.layer.borderWidth = 1
        return card
    }()
    
    
    lazy private var searchTF:UITextField = {
        let lbl = UITextField()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.placeholder = "Search for friends".localized
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        lbl.delegate = self
        return lbl
    }()
    
    
    private let searchIcon:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        return icon
    }()
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    private lazy var tableViewSna:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(FriendContactCell.self, forCellReuseIdentifier: "FriendCellx")
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return table
    }()

    // Sample dummy data
    private let findFriends = ["M Moin", "Vimlesh", "Anand", "Morayo"]
    private let inviteFriends = ["Gopal", "Bharat", "Amit", "Pankaj"]

    private let refreshControl = UIRefreshControl()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        backBtn.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.right" : "arrow.left"), for: .normal)
        backBtn.tintColor = .black
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Suggestions Button
        suggestionsButton.setTitle("Suggestions", for: .normal)
        suggestionsButton.setTitleColor(.label, for: .normal)
        suggestionsButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        suggestionsButton.addTarget(self, action: #selector(selectSuggestions), for: .touchUpInside)
        
        // Friends Button
        friendsButton.setTitle("My Friends", for: .normal)
        friendsButton.setTitleColor(.secondaryLabel, for: .normal)
        friendsButton.titleLabel?.font = .systemFont(ofSize: 16)
        friendsButton.addTarget(self, action: #selector(selectFriends), for: .touchUpInside)

        
        
        
        // Underline View

        [ headerView ,tableViewSna ,tableView].forEach { view in
            self.view.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
      
        tableViewSna.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        [titleView , searchView,tabContainer].forEach { view in
            self.headerView.addSubview(view)
        }
        
        tabContainer.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        tabContainer.addSubview(suggestionsButton)
        tabContainer.addSubview(friendsButton)
        tabContainer.addSubview(underlineView)
        
        underlineView.backgroundColor = .systemPurple
        underlineView.layer.cornerRadius = 2
        underlineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.left.equalToSuperview() // Start under suggestions
        }

        suggestionsButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        friendsButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-4)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        [backBtn , titleLbl].forEach { view in
            self.titleView.addSubview(view)
        }
        
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(32)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        
        searchView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.constraintMultiplierTargetValue.relativeToIphone8Width())
            make.top.equalTo(self.titleLbl.snp.bottom).offset(19.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(56.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        [searchTF , searchIcon ].forEach { view in
            self.searchView.addSubview(view)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        searchTF.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.searchIcon.snp.leading)
            make.top.bottom.equalToSuperview()
        }
        tableView.isHidden = true
        tableViewSna.isHidden = false

        backBtn.tap {
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$friends.receive(on: DispatchQueue.main).sink { friends in
            if self.viewModel.loading {return}
            self.friends = friends
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.$requests.receive(on: DispatchQueue.main).sink { friends in
            if self.viewModel.loading {return}
            if let friends = friends {
                self.refreshControl.endRefreshing()
                self.friends?.insert(contentsOf: friends, at: 0)
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModel.loading {return}
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        viewModel.getFriends()
        setupRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func selectSuggestions() {
        underlineView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.left.equalToSuperview()
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        suggestionsButton.setTitleColor(.label, for: .normal)
        suggestionsButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

        friendsButton.setTitleColor(.secondaryLabel, for: .normal)
        friendsButton.titleLabel?.font = .systemFont(ofSize: 16)
        tableView.isHidden = true
        tableViewSna.isHidden = false

        // TODO: update view to show suggestions
    }

    @objc private func selectFriends() {
        underlineView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.left.equalToSuperview().offset(tabContainer.frame.width * 0.5)
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        friendsButton.setTitleColor(.label, for: .normal)
        friendsButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

        suggestionsButton.setTitleColor(.secondaryLabel, for: .normal)
        suggestionsButton.titleLabel?.font = .systemFont(ofSize: 16)
        tableView.isHidden = false
        tableViewSna.isHidden = true

        // TODO: update view to show friend list
    }

    func setupRefreshControl() {
        refreshControl.tintColor = .accent
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        self.viewModel.getFriends(isPullToRefresh: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.shimmerView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    
    private func hideShimmer(){
        shimmerView.removeFromSuperview()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FriendsViewController:UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableViewSna == tableView {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewSna == tableView {
            return section == 0 ? findFriends.count : inviteFriends.count
        } else {
            return friends?.count ?? 0

        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = section == 0 ? "   Find Friends" : "   Invite to Snapchat"
        header.font = .boldSystemFont(ofSize: 16)
        header.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
        if tableViewSna == tableView {
            return 40
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableViewSna == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCellx", for: indexPath) as! FriendContactCell
            if indexPath.section == 0 {
                cell.configure(name: findFriends[indexPath.row], username: inviteFriends[indexPath.row], buttonTitle: "Add")
            } else {
                cell.configure(name: inviteFriends[indexPath.row], username: inviteFriends[indexPath.row], buttonTitle: "Invite")
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
            let friend = friends?.get(at: indexPath.row)
            cell.friend = friend
            cell.addBtn.tap {
                self.friends?[safe: indexPath.row]?.loading = true
                self.reloadRow(indexPath: indexPath, tableView: tableView)
                self.viewModel.addFriend(friendId: friend?.fid ?? "") { res, err in
                    await MainActor.run {
                       if let _ = res {
                            self.friends?[safe: indexPath.row]?.invitestatus = 1
                        }
                        self.friends?[safe: indexPath.row]?.loading = false
                        self.reloadRow(indexPath: indexPath, tableView: tableView)
                    }
                }
            }
            cell.acceptBtn.tap {
                self.friends?[safe: indexPath.row]?.loading = true
                self.reloadRow(indexPath: indexPath, tableView: tableView)
                self.viewModel.acceptRejectFriendRequest(friendId: friend?.fid ?? "", status: "1") { res, err in
                    await MainActor.run {
                       if let _ = res {
                            self.friends?[safe: indexPath.row]?.invStatus = "1"
                        }
                        self.friends?[safe: indexPath.row]?.loading = false
                        self.reloadRow(indexPath: indexPath, tableView: tableView)
                    }
                }
            }
            cell.rejectBtn.tap {
                self.friends?[safe: indexPath.row]?.loading = true
                self.reloadRow(indexPath: indexPath, tableView: tableView)
                self.viewModel.acceptRejectFriendRequest(friendId: friend?.fid ?? "", status: "2") { res, err in
                    await MainActor.run {
                        if let _ = res {
                            self.friends?.removeIfIndexExists(at: indexPath.row)
                            tableView.performBatchUpdates {
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                            }
                        }else{
                            self.friends?[safe: indexPath.row]?.loading = false
                            self.reloadRow(indexPath: indexPath, tableView: tableView)
                        }
                    }
                }
            }
            return cell

        }
    }
    
    func reloadRow(indexPath:IndexPath , tableView:UITableView){
        UIView.performWithoutAnimation {
            tableView.performBatchUpdates {
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let friend = friends?.get(at: indexPath.row) , let _ = friend.friendCustid{
            let vc = FriendProfileViewController(friend: friend)
            vc.callback = { self.viewModel.getFriends() }
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            nav.isModalInPresentation = true
            self.present(nav, animated: true)
        }else {
            MainHelper.showToastMessage(message: "you_are_not_friends".localized, style: .error, position: .Bottom)
        }
    }
}

extension FriendsViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string){
            if text.isEmpty {
                viewModel.getFriends()
            }else{
                viewModel.findFriend(name: text.lowercased())
            }
        }
        return true
    }
    
}
class FriendContactCell: UITableViewCell {
    
    private let profileImage = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let actionButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let container = UIView()
        container.layer.cornerRadius = 12
        container.backgroundColor = .white
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowRadius = 4
        container.layer.shadowOffset = .zero
        contentView.addSubview(container)

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        [profileImage, nameLabel, usernameLabel, actionButton].forEach { container.addSubview($0) }

        profileImage.layer.cornerRadius = 22
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.tintColor = .gray
        profileImage.contentMode = .scaleAspectFill
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.font = .systemFont(ofSize: 13)
        usernameLabel.textColor = .gray
        
        actionButton.backgroundColor = .systemYellow
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        actionButton.layer.cornerRadius = 16

        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.right.equalTo(actionButton.snp.left).offset(-12)
        }

        usernameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImage.snp.bottom)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameLabel.snp.right)
        }

        actionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, username: String?, buttonTitle: String) {
        nameLabel.text = name
        usernameLabel.text = username
        actionButton.setTitle(buttonTitle, for: .normal)
    }
}
