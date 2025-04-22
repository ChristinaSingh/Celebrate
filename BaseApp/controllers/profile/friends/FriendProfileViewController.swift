//
//  FriendProfileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit
import Combine
import Foundation



enum FriendProfile {
    case details
    case favorites

}
enum FriendTabType: Int {
    case favorites = 0, occasions, addresss
}

class FriendProfileViewController: UIViewController {
    
    private var friend:Friend
    private var friendProfile:[FriendProfile]
    private let viewModel = FriendsViewModel()
    private var likes: [Product] = []
    private var selectedDate:Date = Date()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var addresses: [Address] = []
    private let viewModelA = AddressesViewModel()

    var callback:(() -> Void)?
    init(friend: Friend) {
        self.friend = friend
        self.friendProfile = []
        super.init(nibName: nil, bundle: nil)
    }
    var selectedTab: FriendTabType = .favorites

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "FriendProfile")
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Friend’s profile".localized)
        view.backgroundColor = .white
        return view
    }()
    
    
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FriendProfileDetailsCell.self, forCellWithReuseIdentifier: "FriendProfileDetailsCell")
        return collectionView
    }()
    
    lazy private var collectionViewFavourt:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FriendLikeCell.self, forCellWithReuseIdentifier: "FriendLikeCell")
        return collectionView
    }()
    lazy private var tableView:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(CelebrationCell.self, forCellReuseIdentifier: "CelebrationCell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        return table
    }()
    lazy private var tableViewAddress:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(AddressTableViewCell.self, forCellReuseIdentifier: "AddressTableViewCell")
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        return table
    }()
    private let emptyState:EmptyStateView = {
        let view = EmptyStateView(icon: UIImage(named: "no_addresses"), message: "Looks like you don’t have any saved address".localized, imgSize: CGSize(width: 120, height: 120))
        return view
    }()
    

    
    private let planEventBtn:C8IconButton = {
        let btn = C8IconButton(frame: .zero)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.icon = UIImage(named: "celebrate_line")
        btn.title = "Plan Event".localized
        btn.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        btn.iconColor = .white
        btn.titleColor = .white
        btn.iconSize = CGSize(width: 24, height: 24)
        return btn
    }()
    
    
    private let sendGiftBtn:C8IconButton = {
        let btn = C8IconButton(frame: .zero)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.icon = UIImage(named: "celebrate_gift")
        btn.title = "Send Gift".localized
        btn.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        btn.iconColor = .white
        btn.titleColor = .white
        btn.iconSize = CGSize(width: 24, height: 24)
        return btn
    }()
    
    
    lazy private var actionsStackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [planEventBtn, sendGiftBtn])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    private let tabStackView = UIStackView()
    private let favoritesButton = UIButton(type: .system)
    private let occasionsButton = UIButton(type: .system)
    private let addressButton = UIButton(type: .system)

    func setupTabButtons() {
        favoritesButton.setTitle("Favorites", for: .normal)
        occasionsButton.setTitle("Occasions", for: .normal)
        addressButton.setTitle("Address", for: .normal)
        
        [favoritesButton, occasionsButton, addressButton].forEach {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .clear
            $0.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            tabStackView.addArrangedSubview($0)
        }

        tabStackView.axis = .horizontal
        tabStackView.distribution = .fillEqually
        tabStackView.spacing = 12
        

        updateTabSelection()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        tableView.isHidden = true
        tableViewAddress.isHidden = true

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView , collectionView,tabStackView,collectionViewFavourt,tableView,tableViewAddress,actionsStackView].forEach { view in
            self.containerView.addSubview(view)
        }
        setupTabButtons()

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        actionsStackView.isHidden = true
        actionsStackView.snp.makeConstraints { make in
            make.width.equalTo(290)
            make.height.equalTo(0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom)
            make.height.equalTo(268)
        }
        tabStackView.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }

        collectionViewFavourt.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.tabStackView.snp.bottom).offset(16)
            make.bottom.equalTo(self.actionsStackView.snp.top).offset(-16)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.tabStackView.snp.bottom).offset(16)
            make.bottom.equalTo(self.actionsStackView.snp.top).offset(-16)
        }
        tableViewAddress.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.tabStackView.snp.bottom).offset(16)
            make.bottom.equalTo(self.actionsStackView.snp.top).offset(-16)
        }

        sendGiftBtn.tap = {
            CalendarViewController.show(on: self, cartType: .gift, delegate: self)
        }
        
        planEventBtn.tap = {
            LoadingIndicator.shared.loading(isShow: true)
            OcassionLocation.shared.loadAreas { areas in
                LoadingIndicator.shared.loading(isShow: false)
                if let areas{
                    print(areas.convertToString ?? "")
                    print(self.friend.locationId ?? "")
                    if let area = self.getArea(by: self.friend.locationId ?? "", in: areas){
                        OcassionLocation.shared.save(area: Area(id: area.id, name: self.friend.customer?.username, arName: self.friend.customer?.username, governateID: area.governateID))
                        let vc = AppTabsViewController()
                        vc.selectedIndex = 1
                        if let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate {
                            sceneDelegate.changeRootViewController(vc)
                        }
                    }else{
                        MainHelper.showErrorMessage(message: "Cannot find friend location", isToast: true)
                    }
                }
            }
        }
    
        viewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        
        viewModel.$friendAddresses.dropFirst().receive(on: DispatchQueue.main).sink { addresses in
            if addresses?.isEmpty == false {
                self.actionsStackView.isHidden = false
                self.actionsStackView.snp.updateConstraints { make in
                    make.height.equalTo(32)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$likes.receive(on: DispatchQueue.main).sink { res in
            if self.viewModel.loading {return}
            self.friendProfile.append(.details)
            self.friendProfile.append(.favorites)
            self.likes = res ?? []
            self.collectionViewFavourt.reloadData()
        }.store(in: &cancellables)
        
        viewModel.getFriendProfile(friendId: self.friend.friendCustid ?? "")
        
        
        viewModelA.$addresses.receive(on: DispatchQueue.main).sink { addresses in
            if self.viewModelA.loading {return}
            if let addresses = addresses?.addresses , !addresses.isEmpty {
                self.emptyState.isHidden = true
              // self.tableView.isHidden = false
                self.addresses = addresses
                self.tableViewAddress.reloadData()
            }else{
                self.emptyState.isHidden = true
                self.tableViewAddress.isHidden = true
            }
        }.store(in: &cancellables)
        
        viewModelA.$error.receive(on: DispatchQueue.main).sink{ error in
            if self.viewModelA.loading {return}
            self.emptyState.isHidden = true
            self.tableView.isHidden = true
            MainHelper.handleApiError(error)
        }.store(in: &cancellables)
        
        viewModelA.getAddresses()

        updateReminder(isRemove: false)
    }


        @objc private func tabButtonTapped(_ sender: UIButton) {
            if sender == favoritesButton {
                selectedTab = .favorites
                collectionViewFavourt.isHidden = false
                tableView.isHidden = true
                tableViewAddress.isHidden = true

            } else if sender == occasionsButton {
                selectedTab = .occasions
                collectionViewFavourt.isHidden = true
                tableView.isHidden = false
                tableViewAddress.isHidden = true

            } else {
                selectedTab = .addresss
                collectionViewFavourt.isHidden = true
                tableView.isHidden = true
                tableViewAddress.isHidden = false

            }

            updateTabSelection()
//            collectionView.reloadData()
        }
        private func updateTabSelection() {
            let allButtons = [favoritesButton, occasionsButton, addressButton]
            for (index, button) in allButtons.enumerated() {
                if index == selectedTab.rawValue {
                    button.backgroundColor = UIColor.purple
                    button.setTitleColor(.white, for: .normal)
                } else {
                    button.backgroundColor = UIColor.systemGray5
                    button.setTitleColor(.black, for: .normal)
                }
            }
        }

    private func getArea(by id: String, in items: [Area]) -> Area?{
        for item in items {
            if item.id == id {
                return item
            } else if let found = getArea(by: id, in: item.locations ?? []) {
                return found
            }
        }
        return nil
    }
    
    private func updateReminder(isRemove: Bool){
        if let isReminderSet = self.friend.remindme, isReminderSet == 1, let name = self.friend.customer?.fullname, let month = self.friend.customer?.formateDate()?.month , let day = self.friend.customer?.formateDate()?.day, let userId = User.load()?.details?.id {
            BirthdayReminderManager.shared.removeReminder(for: name, month: month, day: day, userId: userId)
            if isRemove == false {
                BirthdayReminderManager.shared.scheduleReminder(for: name, month: month, day: day, userId: userId)
            }
        }
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

}
extension FriendProfileViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewAddress == tableView {
            return addresses.count
           // return 5

        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableViewAddress == tableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell else {
                return UITableViewCell()
            }
            let name = "Mr Graceful" // Example nickname
            cell.configure(nickname: name)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrationCell") as! CelebrationCell
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
}

extension FriendProfileViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        //return friendProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 1
        } else if collectionView == self.collectionViewFavourt {
            return self.likes.count
        } else {
            return 0

        }
//        switch friendProfile.get(at: section) {
//        case .details:
//            return 1
//        case .favorites:
//            return self.likes.count
//        case .none:
//            return 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileDetailsCell", for: indexPath) as! FriendProfileDetailsCell
            cell.friend = friend
            cell.reminderBtn.tap {
                cell.reminderLoadingView.isHidden = false
                cell.reminderView.isHidden = true
                self.viewModel.friendBirthDayReminder(friendId: self.friend.friendCustid ?? "", status: self.friend.remindme == 1 ? 0 : 1) { data, err in
                    cell.reminderView.isHidden = false
                    cell.reminderLoadingView.isHidden = true
                    if let data = data, let status = data.status, status.string.lowercased() == "success" {
                        self.callback?()
                        self.friend.remindme = self.friend.remindme == 1 ? 0 : 1
                        self.updateReminder(isRemove: self.friend.remindme == 0)
                        cell.updateRemindView(friend: self.friend)
                    }else if let error = err {
                        MainHelper.handleApiError(error)
                    }
                }
            }
            cell.removeBtn.tap {
                cell.removeBtn.isHidden = true
                cell.loadingView.isHidden = false
                self.viewModel.unfriend(friendId: self.friend.friendCustid ?? ""){ data, error in
                    cell.removeBtn.isHidden = false
                    cell.loadingView.isHidden = true
                    MainHelper.handleApiError(error){ code, message in
                        if code == 200 {
                            self.dismiss(animated: true) {
                                self.callback?()
                            }
                        }else {
                            MainHelper.showToastMessage(message: message ?? "", style: .error, position: .Top)
                        }
                    }
                }
            }
            return cell

        } else if collectionView == self.collectionViewFavourt {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendLikeCell", for: indexPath) as! FriendLikeCell
            cell.like = self.likes.get(at: indexPath.row)
            return cell
        } else {
            return UICollectionViewCell()
        }

//        switch friendProfile.get(at: indexPath.section) {
//        case .details:
//        case .favorites:
//        case .none:
//            return UICollectionViewCell()
//        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FriendLikeHeaderReusableView", for: indexPath) as! FriendLikeHeaderReusableView
//        return header
//    }
//    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize(width: collectionView.frame.width, height: 258)
        } else {
            let width = (collectionView.frame.width - 3 * 16) / 3
            return CGSize(width: width, height: width + 32)

        }
//        switch friendProfile.get(at: indexPath.section) {
//        case .details:
//            return CGSize(width: collectionView.frame.width, height: 258)
//        case .favorites:
//            let width = (collectionView.frame.width - 3 * 16) / 3
//            return CGSize(width: width, height: width + 32)
//        default:
//            return .zero
//        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        switch friendProfile.get(at: section) {
//        case .favorites:
//            return CGSize(width: collectionView.frame.width, height: 62)
//        default:
//            return .zero
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let product = likes.get(at: indexPath.row) else { return }
       // self.selectedProduct = product
        if OcassionDate.shared.getEventDate() == nil && OcassionLocation.shared.getArea() == nil {
      //      CalendarViewController.show(on: self, cartType: .normal , selectedDate: OcassionDate.shared.getEventDate() , delegate: self , areaDelegate: self)
        }else{
            let vc = ProductDetailsViewController(product: product)
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
    }
}
extension FriendProfileViewController: DaySelectionDelegate {
    func dayDidSelected(day: Day?) {
        guard let date = day?.date else { return }
        self.selectedDate = date
        let vc = DeliveryTimeViewController(delegate: self)
        vc.isModalInPresentation = true
        self.present(vc, animated: true)
    }
    
    func timeDidSelected(time: PreferredTime?) {
        let vc = GiftsSubCategoriesViewController(date: self.selectedDate, addressId: friend.addressId ?? "", locationId: friend.locationId ?? "", time: time, friend: friend)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class AddressTableViewCell: UITableViewCell {

    static let identifier = "AddressTableViewCell"

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.tintColor = UIColor(hex: "#3D2ABA")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let payNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay Now", for: .normal)
        button.setTitleColor(UIColor(hex: "#3D2ABA"), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        return button
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        cardView.addSubview(locationImageView)
        cardView.addSubview(nicknameLabel)
        cardView.addSubview(payNowButton)

        locationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationImageView)
            make.left.equalTo(locationImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
        }

        payNowButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Configure
    func configure(nickname: String) {
        nicknameLabel.text = nickname
    }
}
