//
//  HomeViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import UIKit
import SnapKit
import Combine

class HomeViewController: BaseViewController, OrderSummeryCellDelegate {
 
    private let cartVC = CartViewController() // Ensure CartViewController exists
    
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
            image: cartImage, //UIImage(named: "cart"), // Make sure to add "cart" icon to assets
            selectedImage: cartSelectedImage //UIImage(named: "cart_selected") // Add "cart_selected" to assets
        )
    }
    func didTapPayNow() {
        print("HomeViewController Pay Now Button Tap")
        cartVC.modalPresentationStyle = .fullScreen
        present(cartVC, animated: true, completion: nil)
    }
    
    private let orderSummeryCell:(HomeCellType , CGFloat) = (.OrderSummery , 170)
    private var cells:[(HomeCellType , CGFloat)] = [(.Celebrate , 318) , (.SurpriseGift , 144) , (.DineOut , 144)]
    private let viewModel:HomeViewModel = HomeViewModel()
    private var order: Cart? = nil
    
    private lazy var tableView:UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.isScrollEnabled = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 60, right: 0)
        table.showsVerticalScrollIndicator = false
        table.register(OrderSummeryCell.self, forCellReuseIdentifier: "OrderSummeryCell")
        table.register(CelebrateTableViewCell.self, forCellReuseIdentifier: "CelebrateTableViewCell")
        table.register(PlanEventTableViewCell.self, forCellReuseIdentifier: "PlanEventTableViewCell")
        table.register(SurpriseGiftTableViewCell.self, forCellReuseIdentifier: "SurpriseGiftTableViewCell")
        table.register(DineOutTableViewCell.self, forCellReuseIdentifier: "DineOutTableViewCell")
        return table
    }()
    
    private let shimmerView: ShimmerView = {
        let view = ShimmerView(nibName: "Home")
        return view
    }()

    private let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    private let welcomeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.textColor = .white
        return lbl
    }()
    
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 2
        return lbl
    }()
    
    
    private let headerView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        view.backgroundColor = .clear
        return view
    }()

    
    override func setup() {
        self.view.backgroundColor = .white
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view.snp.width)
        }
        
        contentView.addSubview(tableView)
        
        [welcomeLbl , messageLbl].forEach { view in
            self.headerView.addSubview(view)
        }
        
        welcomeLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.welcomeLbl.snp.bottom)
        }
        
        tableView.tableHeaderView = headerView
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        
        languageChanged()
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.shimmerView.showShimmer(vc: self)
            }else{
                self.shimmerView.hideShimmer(vc: self)
            }
        }.store(in: &cancellables)
        
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$orders.receive(on: DispatchQueue.main).sink { orders in
            guard let orders = orders else { return }
            if orders.first?.items?.isEmpty == false{
                self.order = orders.first
                self.insertOrderSummery()
            }
        }.store(in: &cancellables)
        
        reloadPendingOrder()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPendingOrder), name: Notification.Name(rawValue: "cart.refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    
    @objc func languageChanged() {
        messageLbl.text = "home_message".localized
        welcomeLbl.text = "\("Hi".localized) \(User.load()?.details?.fullName ?? User.load()?.details?.username ?? "") 👋"
        welcomeLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        messageLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        messageLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 16)
        tableView.reloadData()
        tableView.invalidateIntrinsicContentSize()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        contentView.applyLinearGradient(colors: [
            UIColor(red: 0.365, green: 0.09, blue: 0.922, alpha: 1).cgColor,
            UIColor(red: 0.365, green: 0.09, blue: 0.922, alpha: 0).cgColor
        ] , frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: 1500)))
    }
    
    
    func insertOrderSummery() {
        self.cells.insert(orderSummeryCell, at: 0)
        self.tableView.reloadData()
    }
    
    @objc private func reloadPendingOrder(){
        self.cells.removeAll { (HomeCellType, _) in
            HomeCellType == .OrderSummery
        }
        self.tableView.reloadData()
        viewModel.loadPendingOrders()
    }
}

extension HomeViewController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[safe: indexPath.row]?.1 ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[safe: indexPath.row]?.0 {
        case .OrderSummery:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummeryCell", for: indexPath) as! OrderSummeryCell
            cell.order = self.order
            cell.delegate = self
            return cell
        case .Celebrate:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrateTableViewCell", for: indexPath) as! CelebrateTableViewCell
            cell.titleLbl.text = "Let’s Celebrate".localized
            cell.titleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
            cell.titleLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
            cell.subTitleLbl.text = "celebrate_sub_title".localized
            cell.subTitleLbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
            cell.subTitleLbl.textAlignment = AppLanguage.isArabic() ? .right : .left
            cell.getStartBtn.setTitle("GET STARTED".localized, for: .normal)
            cell.getStartBtn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
            cell.img.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.getStartBtn.tap {
                let vc = GetStartedViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case .SurpriseGift:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurpriseGiftTableViewCell", for: indexPath) as! SurpriseGiftTableViewCell
            cell.sendGiftTitle.text = "Send Gifts".localized
            cell.sendGiftTitle.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
            cell.surpriseTitle.text = "Surprise".localized
            cell.surpriseTitle.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
            cell.surpriseImg.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.sendGiftImg.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.sendGiftTitle.textAlignment = AppLanguage.isArabic() ? .right : .left
            cell.surpriseTitle.textAlignment = AppLanguage.isArabic() ? .right : .left
            cell.surpriseImg.image = UIImage(named: "surprise")
            cell.sendGiftImg.image = UIImage(named: "send_gift")
            cell.surpriseGetStartArrow.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.left" : "arrow.right")?.withTintColor(.secondary), for: .normal)
            cell.sendGiftGetStartBtnArrow.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.left" : "arrow.right")?.withTintColor(.secondary), for: .normal)
            cell.surpriseGetStartBtn.tap {
                let vc = SurpriseIntroViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.sendGiftGetStartBtn.tap {
                let vc = SendGiftsIntroViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case .DineOut:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurpriseGiftTableViewCell", for: indexPath) as! SurpriseGiftTableViewCell
            cell.sendGiftTitle.text = "Event Planners".localized
            cell.sendGiftTitle.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
            cell.surpriseTitle.text = "Pop-ups".localized
            cell.sendGiftTitle.textAlignment = AppLanguage.isArabic() ? .right : .left
            cell.surpriseTitle.textAlignment = AppLanguage.isArabic() ? .right : .left
            cell.surpriseTitle.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 16)
            cell.surpriseImg.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.sendGiftImg.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
            cell.surpriseImg.image = UIImage(named: "dine_out")
            cell.sendGiftImg.image = UIImage(named: "plan_event")
            cell.surpriseGetStartArrow.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.left" : "arrow.right")?.withTintColor(.secondary), for: .normal)
            cell.sendGiftGetStartBtnArrow.setImage(UIImage(systemName: AppLanguage.isArabic() ? "arrow.left" : "arrow.right")?.withTintColor(.secondary), for: .normal)
            cell.surpriseGetStartBtn.tap {
                let vc = DineOutTypesViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.sendGiftGetStartBtn.tap {
                let vc = PlanEventIntroViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
