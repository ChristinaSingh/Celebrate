//
//  ViewCartFloatingView.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/12/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class ViewCartFloatingView: NSObject {
    
    private static var activeInstances: NSHashTable<ViewCartFloatingView> = NSHashTable.weakObjects()
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let cartViewModel:CartViewModel = CartViewModel()
    static var cartItem:Cart? = nil
    private static var isNotificationSubscribed = false
    
    class func newInstance() -> ViewCartFloatingView {
        let instance = ViewCartFloatingView()
        ViewCartFloatingView.activeInstances.add(instance)
        return instance
    }
    private var collectionView:UICollectionView?
    private var viewController:UIViewController?
    
    private let viewCartBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("View Cart".localized, for: .normal)
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return btn
    }()
    
    private let amountLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    let viewCardView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private func subscribeToNotificationCenter() {
        guard !Self.isNotificationSubscribed else { return }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCart), name: Notification.Name("cart.refresh"), object: nil)
        Self.isNotificationSubscribed = true
    }
    
    @objc func reloadCart(){
        self.cartViewModel.fetchCarts()
    }
    
    func setup(on viewController: UIViewController, for collectionView: UICollectionView? = nil){
        cartViewModel.$cart.dropFirst().receive(on: DispatchQueue.main).sink { carts in
            guard let carts = carts else {
                self.removeAllInstances()
                ViewCartFloatingView.cartItem = nil
                return
            }
            ViewCartFloatingView.cartItem = carts.first
            if let cartItem = carts.first, cartItem.items?.isEmpty == false{
                for instance in ViewCartFloatingView.activeInstances.allObjects {
                    instance.setAmount(amount: "\(cartItem.items?.count ?? 0) items | KD \(cartItem.cartTotal ?? 0)")
//                    instance.attach()
                }
            }else{
                self.removeAllInstances()
            }
        }.store(in: &cancellables)
        subscribeToNotificationCenter()
        self.collectionView = collectionView
        self.viewController = viewController
        viewCardView.translatesAutoresizingMaskIntoConstraints = false
        guard let view = viewController.view else {return}
        view.addSubview(viewCardView)
        NSLayoutConstraint.activate([
            viewCardView.heightAnchor.constraint(equalToConstant: 85),
            viewCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            viewCardView.bottomAnchor.constraint(equalTo: collectionView == nil ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: collectionView == nil ? -30 : 0)
        ])
        viewCardView.addSubview(viewCartBtn)
        viewCardView.addSubview(amountLbl)
        viewCartBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(113)
            make.height.equalTo(32)
        }
        
        amountLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.viewCartBtn.snp.centerY)
            make.leading.equalToSuperview().offset(16)
        }
        
        viewCartBtn.tap {
//            let vc = CartViewController()
//            vc.isModalInPresentation = true
//            viewController.present(vc, animated: true)
          //  self.tabBarController?.selectedIndex = 2

        }
        self.removeFromSuperview()
        viewCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if let cartItem = ViewCartFloatingView.cartItem {
            setAmount(amount: "\(cartItem.items?.count ?? 0) items | KD \(cartItem.cartTotal ?? 0)")
            self.attach()
        }
    }
    
    
    func attach() {
        guard let view = viewController?.view else { return }
        view.addSubview(viewCardView)
        viewCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewCardView.heightAnchor.constraint(equalToConstant: 85),
            viewCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewCardView.bottomAnchor.constraint(equalTo: collectionView == nil ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: collectionView == nil ? -30 : 0)
        ])
        
        adjustCollectionViewInsets(add: true)
    }
    
    func removeFromSuperview(){
        viewCardView.removeFromSuperview()
        if let collectionView = collectionView {
            collectionView.contentInset.bottom = 0
        }
    }
    
    func setAmount(amount:String){
        amountLbl.text = amount
    }
    
    func updateSemanticContentAttribute(){
        self.viewCardView.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        self.viewCartBtn.setTitle("View Cart".localized)
    }
    
    func adjustFloatingViewVisibility(isVisible: Bool, animated: Bool, tabBar: UITabBar) {
        let targetAlpha: CGFloat = isVisible ? 1 : 0
        let targetY: CGFloat = isVisible
        ? tabBar.frame.origin.y - 65
        : tabBar.frame.origin.y + self.viewCardView.frame.height
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.viewCardView.alpha = targetAlpha
                self.viewCardView.frame.origin.y = targetY
            })
        } else {
            self.viewCardView.alpha = targetAlpha
            self.viewCardView.frame.origin.y = targetY
        }
    }
    
    
    func detach() {
        adjustCollectionViewInsets(add: false)
        viewCardView.removeFromSuperview()
    }
    
    private func adjustCollectionViewInsets(add: Bool) {
        guard let collectionView = collectionView else { return }
        let additionalInset = viewCardView.frame.height + 30
        collectionView.contentInset.bottom += add ? additionalInset : 0
        collectionView.verticalScrollIndicatorInsets.bottom += add ? additionalInset : 0
    }
    
    
    func removeAllInstances() {
        for instance in ViewCartFloatingView.activeInstances.allObjects {
            instance.detach()
        }
    }
    
}
