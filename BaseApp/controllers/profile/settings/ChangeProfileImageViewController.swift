//
//  ChangeProfileImageViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/12/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine

class ChangeProfileImageViewController: UIViewController {

    private var avatars:[AvatarResponse] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    private var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    @MainActor private lazy var shimmerView: UIView = {
        let view = ShimmerView.getShimmer(name: "Avatars")
        return view
    }()
    
    private let viewModel:ProfileViewModel = ProfileViewModel()
    
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: AvatarCell.id)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
        viewModel.$loading.receive(on: DispatchQueue.main).sink { isLoading in
            if isLoading {
                self.showShimmer()
            }else{
                self.hideShimmer()
            }
        }.store(in: &cancellables)
        
        viewModel.$updateloading.receive(on: DispatchQueue.main).sink { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }.store(in: &cancellables)
        
        viewModel.$error.dropFirst().receive(on: DispatchQueue.main).sink { err in
            MainHelper.handleApiError(err)
        }.store(in: &cancellables)
        
        viewModel.$avatars.dropFirst().receive(on: DispatchQueue.main).sink { avatars in
            self.avatars = avatars ?? []
        }.store(in: &cancellables)
        
        viewModel.$updatedUser.dropFirst().receive(on: DispatchQueue.main).sink { user in
            if let savedUser = User.load() {
                savedUser.details?.avatar?.imageURL = user?.details?.avatar?.imageURL
                savedUser.save()
            }
            self.dismiss(animated: true)
        }.store(in: &cancellables)
        viewModel.getAvatars()
    }
    
    
    private func showShimmer(){
        self.view.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview()
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


extension ChangeProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.id, for: indexPath) as! AvatarCell
        cell.avatarImg.download(imagePath: avatars[safe: indexPath.row]?.imageURL ?? "", size: CGSize(width: 100, height: 100))
        cell.avatarImg.layer.cornerRadius = 50
        cell.avatarImg.layer.borderWidth = 0
        cell.avatarImg.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.updateAvatar(avatarId: avatars[safe: indexPath.row]?.id ?? "")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class AvatarCell: UICollectionViewCell {
    
    static let id = "AvatarCell"
    
    let avatarImg:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(avatarImg)
        avatarImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
