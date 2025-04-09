//
//  VenuTypeViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/09/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class VenuTypeViewController:UIViewController{
    
    private let service: Service
    private var body:PlanEventBody
    private var selectedType:VenueType?
    private var types:[VenueType]{
        didSet{
            collectionView.reloadData()
        }
    }
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let viewModel:PlanEventViewModel = PlanEventViewModel()
    init(service: Service,  body: PlanEventBody) {
        self.service = service
        self.types = []
        self.body = body
        self.selectedType = nil
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Venue type".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(OccasionCell.self, forCellWithReuseIdentifier: "OccasionCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Occasions")
        return view
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
        self.proceedBtn.tap = {
            guard let type = self.selectedType else{return}
            self.body.venueType = AppLanguage.isArabic() ? type.nameAr : type.name
            if type.id == 1 {
                self.viewModel.createEvent(body: self.body)
            }else{
                let vc = PlanEventHotelsViewController(service: self.service, body: self.body)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        observers()
        loadData()
    }
    
    func observers(){
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$venueTypes.dropFirst().receive(on: DispatchQueue.main).sink { types in
            self.types = types
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
        viewModel.getVenueTypes()
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
extension VenuTypeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OccasionCell", for: indexPath) as! OccasionCell
        cell.venu = types[safe: indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2
        return CGSize(width: width, height: 104)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.types.forEachIndexed { index, _ in
            self.types[safe: index]?.isSelected = false
        }
        self.types[safe: indexPath.row]?.isSelected = true
        self.selectedType = self.types[safe: indexPath.row]
        collectionView.reloadData()
        self.proceedBtn.enableDisableSaveButton(isEnable: true)
    }
}
