//
//  TagsView.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/06/2024.
//

import UIKit
import SnapKit

class TagsView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var tags: [(icon: String?, text: String)]
    var collectionView: ContentSizedCollectionView!
    
    init(frame: CGRect, tags: [(icon: String?, text: String)]) {
        self.tags = tags
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        let layout = CenteredFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView = ContentSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as! TagCell
        let tag = tags[indexPath.item]
        cell.configure(icon: tag.icon, text: tag.text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = tags[indexPath.item].text.width(withConstrainedHeight: 32, font: AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)!)
        return CGSize(width: width + 46, height: 32)
    }
    
    
    func setTags(tags:[(icon: String?, text: String)]){
        self.tags = tags
        self.collectionView.reloadData()
    }
    
    
    func calculateCollectionViewHeight() -> CGFloat{
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }

}

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 0.1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: C8Label = {
        let label = C8Label()
        label.textColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(textLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
            make.leading.equalToSuperview().offset(12)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.iconImageView.snp.centerY)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(8)
        }
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(icon: String?, text: String) {
        iconImageView.download(imagePath: icon ?? "", size: CGSize(width: 16, height: 16))
        textLabel.text = text
    }
}

class CenteredFlowLayout: UICollectionViewFlowLayout {
    
    required init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()
        
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }
        
        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        
        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Get the total width of the cells on the same row
            let cellsTotalWidth = attributes.reduce(CGFloat(0)) { (partialWidth, attribute) -> CGFloat in
                partialWidth + attribute.size.width
            }
            
            // Calculate the initial left inset
            let totalInset = collectionView!.safeAreaLayoutGuide.layoutFrame.width - cellsTotalWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(attributes.count - 1)
            var leftInset = (totalInset / 2 * 10).rounded(.down) / 10 + sectionInset.left
            
            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }
        
        return layoutAttributes
    }
    
}
