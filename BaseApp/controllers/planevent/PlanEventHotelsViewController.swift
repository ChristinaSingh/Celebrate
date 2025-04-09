//
//  PlanEventHotelsViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 30/11/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine


class PlanEventHotelsViewController: UIViewController {
    
    private let service: Service
    private var body:PlanEventBody
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:PlanEventViewModel = PlanEventViewModel()
    private var hotels: [VenueHotel]{
        didSet{
            self.collectionView.reloadData()
        }
    }
    init(service: Service, body: PlanEventBody) {
        self.service = service
        self.body = body
        self.hotels = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Hotels")
        return view
    }()
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Venue - Hotel".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FriendLikeCell.self, forCellWithReuseIdentifier: "FriendLikeCell")
        return collectionView
    }()
    
    private let proceedCardView:CardView = {
        let card = CardView()
        card.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        card.shadowOpacity = 1
        card.cornerRadius = 20
        card.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        card.backgroundColor = .white
        card.clipsToBounds = true
        return card
    }()
    
    
    
    lazy var proceedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: false)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        headerView.back(vc: self)
        [headerView, collectionView, proceedCardView].forEach { view in
            self.view.addSubview(view)
        }
        
        proceedCardView.addSubview(self.proceedBtn)
        self.proceedBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        proceedCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.bottom.equalTo(self.proceedCardView.snp.top)
        }
        observers()
        loadData()
        actions()
    }
    
    func observers(){
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$hotels.dropFirst().receive(on: DispatchQueue.main).sink { hotels in
            self.hotels = hotels
        }.store(in: &cancellables)
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading{
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$bookLoading.receive(on: DispatchQueue.main).sink { isLoading in
            self.proceedBtn.loading(isLoading)
        }.store(in: &cancellables)
        
        viewModel.$planEvent.dropFirst().receive(on: DispatchQueue.main).sink { res in
            if res?.status?.boolean == true {
                let vc = ReplacementViewController(service: self.service, appid: res?.data?.id ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                MainHelper.showToastMessage(message: res?.message ?? "something went wrong", style: .error, position: .Top)
            }
        }.store(in: &cancellables)
        
    }
    
    func loadData(){
        self.viewModel.getHotels()
    }
    
    func actions(){
        self.proceedBtn.tap = {
            self.body.hotels = self.hotels.filter{ $0.isSelected }.map { $0.id ?? "" }  .joined(separator: ",")
            self.viewModel.createEvent(body: self.body)
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

extension PlanEventHotelsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendLikeCell", for: indexPath) as! FriendLikeCell
        cell.hotel = self.hotels.get(at: indexPath.row)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3 * 16) / 3
        return CGSize(width: width, height: width + 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hotels[safe: indexPath.row]?.isSelected.toggle()
        let thereIsSelection = self.hotels.filter { $0.isSelected }.isEmpty == false
        self.proceedBtn.enableDisableSaveButton(isEnable: thereIsSelection)
        collectionView.reloadItems(at: [indexPath])
    }
}
