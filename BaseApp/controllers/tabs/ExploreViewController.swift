//
//  ExploreViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit
import Combine

class FloatingButton: UIButton {
    
    private let badgeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupBadge()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setupBadge()
    }

    private func setupButton() {
        
        self.backgroundColor = UIColor(red: 0.24, green: 0.16, blue: 0.73, alpha: 1)
        self.layer.cornerRadius = 30 // Circular button
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.setImage(UIImage(systemName: "cart"), for: .normal) // SF Symbol
        self.tintColor = .white
        
    }

    private func setupBadge() {
        
        badgeLabel.backgroundColor = .red
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.layer.masksToBounds = true
        badgeLabel.isHidden = true // Hide initially
        self.addSubview(badgeLabel)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let badgeSize: CGFloat = 24
        badgeLabel.frame = CGRect(x: self.bounds.width - badgeSize,
                                  y: -badgeSize / 4,
                                  width: badgeSize,
                                  height: badgeSize)
    }

    func updateBadge(count: Int) {
        if count > 0 {
            badgeLabel.text = "\(count)"
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }
    }
}

class ExploreViewController: UIViewController {
    
    static let shared = ExploreViewController()
    
    fileprivate var cellHeights: [Int: [Int: CGFloat]] = [:]
    private var headerHeight: CGFloat = 190
    private var viewModel: ExploreViewModel = ExploreViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    private let cartVC = CartViewController() // Ensure CartViewController exists
    private let floatingButton = FloatingButton()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()

    private let headerView: ExploreHeader = {
        let header = ExploreHeader(frame: .zero)
        header.backgroundColor = .clear
        header.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        header.layer.shadowOpacity = Float(0)  // Adjust shadow opacity based on alpha
        header.layer.shadowOffset = CGSize(width: 0, height: 8)  // Shadow position
        header.layer.shadowRadius = 8  // Shadow radius
        return header
    }()

    func resizeImage(named: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    //Tap action for cartIcon
    private func createCartVC() {
        let cartImage = resizeImage(named: "cart", size: CGSize(width: 22, height: 22))
        let cartSelectedImage = resizeImage(named: "cart_selected", size: CGSize(width: 22, height: 22))

        //cartVC.modalPresentationStyle = .pageSheet
        cartVC.tabBarItem = UITabBarItem(
            title: "Cart".localized,
            image: cartImage,
            selectedImage: cartSelectedImage
        )
    }

    @objc private func handleCartIconTapped() {
        print("Cart Icon Tapped")
        setupCartCount()
        cartVC.modalPresentationStyle = .fullScreen
        present(cartVC, animated: true)
    }

    // Listener for cart count
    public func setupCartCount() {

        self.cartVC.cartViewModel.fetchCarts()
        cartVC.cartViewModel.$cart.receive(on: DispatchQueue.main).sink { carts in
            guard let carts = carts,
                  !carts.isEmpty,
                  !carts.allSatisfy({ $0.items?.isEmpty == true })
            else {
                self.updateCartBadge(count: 0)
                return
            }

            let itemCount = carts.reduce(0) { $0 + ($1.items?.count ?? 0) }
            print("carts.count \(itemCount) \(carts.count)")

            self.updateCartBadge(count: itemCount)
        }.store(in: &self.cancellables)
    }

    // Badge functionality
    private func updateCartBadge(count: Int) {
        if(count == 0)
        {
            floatingButton.isHidden = true
            if let cartTabBarItem = tabBarController?.tabBar.items?[2] {
                cartTabBarItem.badgeValue = "0" // Your cart count
            }

        }
        else
        {
            floatingButton.isHidden = true
            DispatchQueue.main.async {
                self.floatingButton.updateBadge(count: count)
                
                print("countcountcount \(count)")

                
                if let cartTabBarItem = self.tabBarController?.tabBar.items?[2] {
                    cartTabBarItem.badgeValue = "\(count)" // Your cart count
                }

            }
        }
    }
//Item added, updated
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(BannersCell.self, forCellReuseIdentifier: "BannersCell")
        table.register(CategoriesCell.self, forCellReuseIdentifier: "CategoriesCell")
        table.register(VendorsCell.self, forCellReuseIdentifier: "VendorsCell")
        table.register(NewArrivalsCell.self, forCellReuseIdentifier: "NewArrivalsCell")
        table.register(OffersCell.self, forCellReuseIdentifier: "OffersCell")
        table.register(SurpriseCell.self, forCellReuseIdentifier: SurpriseCell.identifier)
        table.register(PopUpsCell.self, forCellReuseIdentifier: PopUpsCell.identifier)
        table.register(ContactsUsCell.self, forCellReuseIdentifier: "ContactsUsCell")
        table.register(EventPlannersCell.self, forCellReuseIdentifier: "EventPlannersCell")
        table.register(LetsCelebrateCell.self, forCellReuseIdentifier: "LetsCelebrateCell")
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()

    private var banners: Banners = []
    private var game: Banners = []
    private var corprate: Banners = []
    private var categories: [Category]?
    private var vendors: [Vendor]?
    private var types: [ExploreType] = []
    private var newArrivals: NewArrivals?
    private var topPicks: NewArrivals?
    private var offers: NewArrivals?
    private var planners: Planners?
    private let shimmerView: ShimmerView = {
        let view = ShimmerView(nibName: "ExploreShimmer")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        observers()
        setup()
        actions()
        loadData()

        // Cart Process
        createCartVC()
        setupFloatingButton()
        setupCartCount()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCartRefresh(_:)), name: Notification.Name("cart.refresh"), object: nil)


    }
    @objc private func handleCartRefresh(_ notification: Notification) {
        if let stringValue = notification.object as? String {
            if let cartTabBarItem = self.tabBarController?.tabBar.items?[2] {
                cartTabBarItem.badgeValue = "\(stringValue)" // Your cart count
            }

            print("Received string: \(stringValue)")
        }
    }

    private func setupFloatingButton() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first {
            keyWindow.addSubview(floatingButton)

            floatingButton.translatesAutoresizingMaskIntoConstraints = false
            floatingButton.addTarget(self, action: #selector(handleCartIconTapped), for: .touchUpInside)

            NSLayoutConstraint.activate([
                floatingButton.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -20),
                floatingButton.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -80),
                floatingButton.widthAnchor.constraint(equalToConstant: 60),
                floatingButton.heightAnchor.constraint(equalToConstant: 60)
            ])

            // Bring the button to the front
            keyWindow.bringSubviewToFront(floatingButton)
        }
    }

    private func setup() {
        view.backgroundColor = .white
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        contentView.sendSubviewToBack(tableView)

        // Helper to format the date with year.
        func formattedDateString(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: date)
        }
        func formattedDateStringT(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: date)
        }

        // Set the event date card's title
        if let date = OcassionDate.shared.getEventDate() {
            self.headerView.eventDateBtn.title = formattedDateString(for: date)
            self.headerView.eventTimeBtn.title = OcassionDate.shared.getTime()

        }

        // Removed references to `eventTimeBtn` here
        // If needed, remove these lines entirely if you no longer want to handle time at all:
        // if let time = OcassionDate.shared.getTime() {
        //     self.headerView.eventTimeBtn.title = time
        // }

        // Set the event location card's title
        if let area = OcassionLocation.shared.getArea() {
            let locationText = AppLanguage.isArabic() ? (area.arName ?? "") : (area.name ?? "")
            self.headerView.eventLocationBtn.title = locationText
        }
    }

    // (Optional) If you need time logic, but no UI for it, you can keep the following helper functions.
    // If not, feel free to remove them:
    func combinedDateTimeString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let formattedDate = dateFormatter.string(from: date)
        let selectedTime = OcassionDate.shared.getTime() ?? ""
        return "\(selectedTime)\n\(formattedDate)"
    }

    func combinedDateTimeAttributedString(for date: Date) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let formattedDate = dateFormatter.string(from: date)
        
        let selectedTime = OcassionDate.shared.getTime() ?? ""
        
        let combinedString = "\(selectedTime)\n\(formattedDate)"
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14),
            .foregroundColor: UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        ]
        return NSAttributedString(string: combinedString, attributes: attributes)
    }

    func loadData() {
        if OcassionDate.shared.getEventDate() == nil && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: self
            )
        } else {
            self.types.removeAll()
            viewModel.loadData(eventDate: OcassionDate.shared.getDate(),
                               eventLocation: OcassionLocation.shared.getAreaId())
        }
    }

    private func actions() {
        headerView.eventDateBtn.tap = {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: OcassionLocation.shared.getAreaId().isEmpty ? self : nil
            )
        }
        headerView.eventTimeBtn.tap = {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: OcassionLocation.shared.getAreaId().isEmpty ? self : nil
            )
        }

        headerView.eventLocationBtn.tap = {
            if OcassionDate.shared.getEventDate() == nil {
                CalendarViewController.show(
                    on: self,
                    cartType: .normal,
                    selectedDate: OcassionDate.shared.getEventDate(),
                    delegate: self,
                    areaDelegate: OcassionLocation.shared.getAreaId().isEmpty ? self : nil
                )
            } else {
                AreasViewController.show(on: self, delegate: self)
            }
        }

        headerView.searchBtn.tap {
            let vc = SearchViewController()
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
        }
    }

    private func observers() {
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    self.shimmerView.showShimmer(vc: self)
                } else {
                    self.shimmerView.hideShimmer(vc: self)
                }
            }.store(in: &cancellables)

        viewModel.$banners
            .receive(on: DispatchQueue.main)
            .sink { banners in
                if let banners = banners {
                    self.banners = banners.filter { banner in
                        banner.hyperlinktype?.lowercased() != "game"
                    }
                    
                    if !self.banners.isEmpty {
                        self.types.append(.Banner)
                    }
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { categories in
                if let categories = categories {
                    self.categories = categories.categories
                    self.types.append(.Categories)
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$vendors
            .receive(on: DispatchQueue.main)
            .sink { vendors in
                if let vendors = vendors {
                    self.vendors = vendors.vendors
                    self.types.append(.Vendors)
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$newArrivals
            .receive(on: DispatchQueue.main)
            .sink { newArrivals in
                if let newArrivals = newArrivals {
                    self.newArrivals = newArrivals
                    self.types.append(.NewArrivals)
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$offers
            .receive(on: DispatchQueue.main)
            .sink { offers in
                if let offers = offers {
                    self.offers = offers
                    self.types.append(.Offers)
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$topPicks
            .receive(on: DispatchQueue.main)
            .sink { topPicks in
                if let topPicks = topPicks {
                    self.topPicks = topPicks
                    self.types.append(.TopPicks)
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$planners
            .receive(on: DispatchQueue.main)
            .sink { planners in
                if let planners = planners {
                    self.planners = planners
                    self.types.append(.Planners)
                    self.reloadTable()
                }
            }.store(in: &cancellables)

        viewModel.$vendorLoading
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                LoadingIndicator.shared.loading(isShow: isLoading)
            }.store(in: &cancellables)

        viewModel.$vendor
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { vendor in
                guard let vendor else { return }
                self.show(vendor: vendor)
            }.store(in: &cancellables)
    }

    private func sortTypes() {
        self.types = self.types.sorted { $0.rawValue < $1.rawValue }
    }

    private func reloadTable() {
        self.types.removeAll { type in
            type == .ContactsUs
            || type == .LetsCelebrate
            || type == .Surprise
            || type == .PopUps
        }
        self.types.append(.PopUps)
        self.types.append(.Surprise)
        self.types.append(.ContactsUs)
        self.types.append(.LetsCelebrate)
        self.sortTypes()
        self.tableView.reloadData()
    }
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let type = types.get(at: indexPath.row) {
            switch type {
            case .Banner:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersCell", for: indexPath) as! BannersCell
                cell.showBanners(banners: self.banners, delegate: self)
                return cell
            case .Categories:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
                cell.showCategoreis(categories: categories, delegate: self)
                return cell
            case .PopUps:
                let cell = tableView.dequeueReusableCell(withIdentifier: PopUpsCell.identifier, for: indexPath) as! PopUpsCell
                cell.exploreBtn.tap {
                    let vc = DineOutTypesViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            case .Vendors:
                let cell = tableView.dequeueReusableCell(withIdentifier: "VendorsCell", for: indexPath) as! VendorsCell
                cell.showVendors(vendors: vendors, delegate: self)
                return cell
            case .NewArrivals:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewArrivalsCell", for: indexPath) as! NewArrivalsCell
                cell.show(products: self.newArrivals?.products ?? [], delegate: self)
                return cell
            case .Surprise:
                let cell = tableView.dequeueReusableCell(withIdentifier: SurpriseCell.identifier, for: indexPath) as! SurpriseCell
                cell.showBanners(banners: corprate)
                cell.exploreBtn.tap {
                    let vc = SurpriseIntroViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            case .Offers:
                let cell = tableView.dequeueReusableCell(withIdentifier: "OffersCell", for: indexPath) as! OffersCell
                cell.show(products: offers?.products ?? [], delegate: self)
                return cell
            case .TopPicks:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewArrivalsCell", for: indexPath) as! NewArrivalsCell
                cell.show(products: self.topPicks?.products ?? [], type: .TopPicks, delegate: self)
                return cell
            case .ContactsUs:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsUsCell", for: indexPath) as! ContactsUsCell
                cell.tellUsBtn.tap {
                    let vc = GetStartedViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            case .Planners:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventPlannersCell", for: indexPath) as! EventPlannersCell
                cell.show(planners: planners, delegate: self)
                return cell
            case .LetsCelebrate:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LetsCelebrateCell", for: indexPath) as! LetsCelebrateCell
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let type = types.get(at: indexPath.row) {
            switch type {
            case .Banner:
                return 200
            case .Categories:
                return 358
            case .PopUps:
                return 206
            case .Surprise:
                return 206
            case .Vendors:
                return 444
            case .NewArrivals, .TopPicks:
                return 361
            case .Offers:
                return 493
            case .ContactsUs:
                return 242
            case .Planners:
                return 340
            case .LetsCelebrate:
                return 227
            }
        }
        return 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let alpha = min(1, y / headerHeight)
        headerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        headerView.layer.shadowOpacity = Float(alpha)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dict = cellHeights[indexPath.section] {
            if dict.keys.contains(indexPath.row) {
                return dict[indexPath.row]!
            } else {
                cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
                return UITableView.automaticDimension
            }
        }

        cellHeights[indexPath.section] = [:]
        cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
        return cellHeights[indexPath.section]![indexPath.row]!
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if let dict = cellHeights[indexPath.section],
           dict[indexPath.row] == UITableView.automaticDimension {
            cellHeights[indexPath.section]![indexPath.row] = cell.bounds.height
        }
    }
}

extension ExploreViewController: ExploreActions {
    func viewAllPlanners() {
        let vc = AllPlannersViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func viewAllTopPicks() {
        let vc = FeaturedViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func viewAllNewArrivals() {
        let vc = NewArrivalsViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func viewAllOffers() {
        let vc = OffersViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func show(product: Product) {
        if OcassionDate.shared.getEventDate() == nil
            && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: self
            )
        } else {
            let vc = ProductDetailsViewController(product: product)
            vc.isModalInPresentation = true
            vc.callback = { cartItem in
                guard let tabBarController = (self.tabBarController as? AppTabsViewController) else { return }
                let instance = tabBarController.instance
                instance.setAmount(amount: "\(cartItem?.items?.count ?? 0) items | KD \(cartItem?.cartTotal ?? 0)")
                tabBarController.showCartView()
            }
            self.present(vc, animated: true)
        }
    }

    func show(banner: Banner) {
        let type = banner.hyperlinktype
        switch type {
        case BannerType.CATEGORY.type:
            guard let category = self.categories?.first(where: { category in
                category.id == banner.categoryid
            }) else {
                return
            }
            show(category: category)
        case BannerType.ITEM.type:
            self.show(product: Product(id: banner.productid))
        case BannerType.URL.type:
            if let url = URL(string: banner.hyperlink ?? "") {
                UIApplication.shared.open(url)
            }
        case BannerType.VENDOR.type:
            self.viewModel.getVendorDetails(vendorId: banner.vendorid ?? "")
        case BannerType.CORPORATE.type:
            break
        case BannerType.GAME.type:
            let vc = SurpriseIntroViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

    func show(category: Category) {
        if OcassionDate.shared.getEventDate() == nil
            && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: self
            )
        } else {
            let vc = CategoryItemsViewController(category: category)
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
        }
    }

    func viewAllCompanies() {
        if OcassionDate.shared.getEventDate() == nil
            && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: self
            )
        } else {
            let vc = CompaniesViewController()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
        }
    }

    func show(vendor: Vendor) {
        if OcassionDate.shared.getEventDate() == nil
            && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: self
            )
        } else {
            let vc = CompanyProfileViewController(vendor: vendor)
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
        }
    }

    func show(planner: Planner) {
        if OcassionDate.shared.getEventDate() == nil
            && OcassionLocation.shared.getArea() == nil {
            CalendarViewController.show(
                on: self,
                cartType: .normal,
                selectedDate: OcassionDate.shared.getEventDate(),
                delegate: self,
                areaDelegate: self
            )
        } else {
            let vc = PlannerProfileViewController(planner: planner, service: .PlanEvent)
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: self)
        }
    }
}

extension ExploreViewController: DaySelectionDelegate, AreaSelectionDelegate {

    // Helper function to format the date
    private func formattedDateString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    private func formattedDateStringD(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }

    func dayDidSelected(day: Day?) {
        if let day = day {
            OcassionDate.shared.save(date: DateFormatter.standard.string(from: day.date))

            // Update only the date card
            self.headerView.eventDateBtn.title = formattedDateString(for: day.date)
            self.headerView.eventTimeBtn.title = OcassionDate.shared.getTime()

            // If needed, remove check for time if you're not using it:
            if OcassionLocation.shared.getArea() != nil, OcassionDate.shared.getTime() != nil {
                self.loadData()
            }
        }
    }

    func timeDidSelected(time: PreferredTime?) {
        if let time = time {
            // Save the selected time
            OcassionDate.shared.saveTime(time: time.displaytext ?? "")
            self.headerView.eventTimeBtn.title = time.displaytext ?? ""

            // Removed references to `eventTimeBtn` since it no longer exists
            if OcassionDate.shared.getDate() != nil,
               OcassionLocation.shared.getArea() != nil {
                self.loadData()
            }
        }
    }

    func areaDidSelected(area: Area?) {
        if let area = area {
            OcassionLocation.shared.save(area: area)
            self.headerView.eventLocationBtn.title = AppLanguage.isArabic() ? (area.arName ?? "") : (area.name ?? "")
            if let _ = OcassionDate.shared.getDate(), let _ = OcassionDate.shared.getTime() {
                self.loadData()
            }
        }
    }
}
