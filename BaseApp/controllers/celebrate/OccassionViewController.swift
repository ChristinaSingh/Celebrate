//
//  OccassionViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class OccassionViewController: UIViewController {
    
    private let area:Area?
    private let day:Day?
    private let time:TimeSlot?
    internal let viewModel:CelebrateViewModel
    var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private var occassions: [CelebrateOcassion]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    private let service:Service
    init(area: Area?, day: Day?, time: TimeSlot?) {
        self.area = area
        self.day = day
        self.time = time
        self.occassions = nil
        self.service = .none
        self.viewModel = CelebrateViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(service:Service){
        self.service = service
        self.area = nil
        self.day = nil
        self.time = nil
        self.occassions = nil
        self.viewModel = CelebrateViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "What are you celebrating?".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    lazy var collectionView:UICollectionView = {
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
        
        observers()
        loadData()
        actions()
    }
    
    
    func observers(){
        viewModel.$error.receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$occassions.receive(on: DispatchQueue.main).sink { occasions in
            self.occassions = occasions?.data?.ocassions
        }.store(in: &cancellables)
        
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading{
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
    }
    
    func loadData(){
        viewModel.loadOccassions()
    }
    
    func actions(){
        self.proceedBtn.tap = {
            let occassions = self.occassions?.filter({ occasion in
                occasion.isSelected
            }) ?? []
            self.navigationController?.pushViewController(CelebrateCategoriesViewController(area: self.area, day: self.day, time: self.time, occasions: occassions), animated: true)

        }
    }
    
    func showShimmer(){
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
    
    
    func hideShimmer(){
        shimmerView.removeFromSuperview()
    }
}
extension OccassionViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return occassions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OccasionCell", for: indexPath) as! OccasionCell
        cell.occasion = occassions?[safe:indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2
        return CGSize(width: width, height: 104)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.occassions?.forEachIndexed({ index, _ in
            self.occassions?[index].isSelected = false
        })
        if self.occassions?.get(at: indexPath.row)?.isSelected == true {
            self.occassions?[safe:indexPath.row]?.isSelected = false
        }else{
            self.occassions?[safe:indexPath.row]?.isSelected = true
        }
        self.proceedBtn.enableDisableSaveButton(isEnable: self.occassions?.filter({ occasion in
            occasion.isSelected
        }).count ?? 0 > 0)
    }
}
