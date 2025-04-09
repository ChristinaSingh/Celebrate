//
//  FriendProfileViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 17/05/2024.
//

import UIKit
import SnapKit
import Combine


enum FriendProfile {
    case details
    case favorites
}

class FriendProfileViewController: UIViewController {
    
    private var friend:Friend
    private var friendProfile:[FriendProfile]
    private let viewModel = FriendsViewModel()
    private var likes: [Product] = []
    private var selectedDate:Date = Date()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
  
    var callback:(() -> Void)?
    init(friend: Friend) {
        self.friend = friend
        self.friendProfile = []
        super.init(nibName: nil, bundle: nil)
    }
    
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
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FriendProfileDetailsCell.self, forCellWithReuseIdentifier: "FriendProfileDetailsCell")
        collectionView.register(FriendLikeCell.self, forCellWithReuseIdentifier: "FriendLikeCell")
        collectionView.register(FriendLikeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FriendLikeHeaderReusableView")
        return collectionView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.cancel(vc: self)
        [headerView , collectionView, actionsStackView].forEach { view in
            self.containerView.addSubview(view)
        }
        
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
            self.collectionView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.getFriendProfile(friendId: self.friend.friendCustid ?? "")
        updateReminder(isRemove: false)
        
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
extension FriendProfileViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return friendProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch friendProfile.get(at: section) {
        case .details:
            return 1
        case .favorites:
            return self.likes.count
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch friendProfile.get(at: indexPath.section) {
        case .details:
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
        case .favorites:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendLikeCell", for: indexPath) as! FriendLikeCell
            cell.like = self.likes.get(at: indexPath.row)
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FriendLikeHeaderReusableView", for: indexPath) as! FriendLikeHeaderReusableView
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch friendProfile.get(at: indexPath.section) {
        case .details:
            return CGSize(width: collectionView.frame.width, height: 258)
        case .favorites:
            let width = (collectionView.frame.width - 3 * 16) / 3
            return CGSize(width: width, height: width + 32)
        default:
            return .zero
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch friendProfile.get(at: section) {
        case .favorites:
            return CGSize(width: collectionView.frame.width, height: 62)
        default:
            return .zero
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
