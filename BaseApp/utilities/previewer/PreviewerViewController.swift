//
//  PreviewerViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/06/2024.
//

import Foundation
import UIKit

class PreviewerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var imageURLs: [String] = []
    var selectedIndex:Int? = nil
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("preview urls \(imageURLs)")
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.register(PreviewerCollectionViewCell.self, forCellWithReuseIdentifier: PreviewerCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
            if let selectedIndex = self.selectedIndex {
                self.collectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewerCollectionViewCell.identifier, for: indexPath) as! PreviewerCollectionViewCell
        print("preview url \(imageURLs[safe: indexPath.row] ?? "")")
        cell.imageView.download(imagePath: imageURLs[indexPath.item], size: collectionView.frame.size)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    
    class func show( _ urls: [String] , selectedIndex:Int? = nil){
        let vc = PreviewerViewController()
        vc.imageURLs = urls
        vc.selectedIndex = selectedIndex
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController?.topMostViewController.present(vc, animated: true)
        }
    }
}
