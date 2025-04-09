//
//  PlannerGalleryCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 16/09/2024.
//

import UIKit
import SnapKit

class PlannerGalleryCell: UITableViewCell {
    
    lazy private var galleryCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        cv.layer.cornerRadius = 16
        cv.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        cv.clipsToBounds = true
        return cv
    }()
    
    
    var gallery:[Gallery] = []{
        didSet{
            self.galleryCV.reloadData()
            let itemWidth = self.frame.width / 2
            let height = gallery.count % 2 == 0 ? (itemWidth * CGFloat(gallery.count) / 2) : itemWidth * CGFloat(Int(CGFloat(gallery.count) / 2) + 1)
            self.galleryCV.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(galleryCV)
        self.galleryCV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PlannerGalleryCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        cell.gallery = gallery[safe:indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.width - 48) / 2
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PreviewerViewController.show(gallery.map({ img in
            img.imageURL ?? ""
        }), selectedIndex: indexPath.row)
    }
}
