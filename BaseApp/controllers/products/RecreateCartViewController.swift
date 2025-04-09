//
//  RecreateCartViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine



class RecreateCartViewController: UIViewController {
    
    
    private var cart:Cart?
    private let cartViewModel:CartViewModel
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let error:CartError?
    init(cartViewModel: CartViewModel, error:CartError?) {
        self.error = error
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "Create new Cart".localized.capitalized)
        view.backgroundColor = .white
        view.cancelBtn.isHidden = true
        return view
    }()
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let messageLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "Your current cart is associated with a different type. It will be deleted, and a new cart will be created for the selected type.".localized
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 16)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let createCartBtn:LoadingC8Button = {
        let btn = LoadingC8Button()
        btn.setTitle("Create Cart".localized.capitalized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .accent
        btn.loadingTintColor = .white
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    
    private let cancelBtn:LoadingC8Button = {
        let btn = LoadingC8Button()
        btn.setTitle("Cancel".localized.capitalized, for: .normal)
        btn.setTitleColor(UIColor.accent, for: .normal)
        btn.backgroundColor = .white
        btn.loadingTintColor = .accent
        btn.layer.borderColor = UIColor.accent.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy private var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createCartBtn, cancelBtn])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    var callback:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.cancel(vc: self)
        [headerView, messageLbl, stackView].forEach { view in
            self.containerView.addSubview(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.messageLbl.snp.bottom).offset(20)
        }
        
        createCartBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        if let error = self.error {
            switch error {
            case .typeMismatch(let cart):
                self.cart = cart
                messageLbl.text = "Your current cart is associated with a different type. It will be deleted, and a new cart will be created for the selected type.".localized
                break
            case .locationMismatch(let cart):
                self.cart = cart
                messageLbl.text = "Your current cart is associated with a different location. It will be deleted, and a new cart will be created for the selected type.".localized
                break
            case .dateMismatch(let cart):
                self.cart = cart
                messageLbl.text = "Your current cart is associated with a different date. It will be deleted, and a new cart will be created for the selected type.".localized
                break
            case .timeMismatch(let cart):
                self.cart = cart
                messageLbl.text = "Your current cart is associated with a different time. It will be deleted, and a new cart will be created for the selected type.".localized
                break
            }
        }
        
        self.cartViewModel.$loading.dropFirst().receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.createCartBtn.showLoading()
                self.cancelBtn.showLoading()
            }else{
                self.createCartBtn.hideLoading()
                self.cancelBtn.hideLoading()
            }
        }.store(in: &cancellables)
        
        cartViewModel.$cartDeleted.receive(on: DispatchQueue.main).sink { deletedCart in
            if let _ = deletedCart {
                self.dismiss(animated: true){
                    self.callback?()
                }
            }
        }.store(in: &cancellables)
        
        createCartBtn.tap {
            self.cartViewModel.deleteCart(id: self.cart?.id ?? "")
        }
        cancelBtn.tap {
            self.dismiss(animated: true)
        }
    }
}
