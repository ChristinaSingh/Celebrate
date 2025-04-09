//
//  ProductDetailsDeliveryTimeCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit

class ProductDetailsDeliveryTimeCell: ProductDetailsCell {
    
    
    var deliveryTimes:DeliveryTimes?{
        didSet{
            self.timeSlotType.type = deliveryTimes?.timeType ?? .AM
            if self.deliveryTimes?.am()?.isEmpty == true || self.deliveryTimes?.pm()?.isEmpty == true{
                timeSlotType.isHidden = true
                timeSlotType.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.timeSlotType.type = self.deliveryTimes?.am()?.isEmpty == true ? .PM : .AM
            }else{
                timeSlotType.snp.updateConstraints { make in
                    make.height.equalTo(40)
                }
            }
            self.timesCV.reloadData()
            self.timesCV.layoutIfNeeded()
        }
    }
    
    let timeSlotType:TimeSlotsSegmentControl = {
        let view = TimeSlotsSegmentControl()
        return view
    }()
    

    lazy var timesCV:ContentSizedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = ContentSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.layer.cornerRadius = 8
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.register(TimeSlotCell.self, forCellWithReuseIdentifier: "TimeSlotCell")
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return cv
    }()
    
    
    var delegate:TimeSlotDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        [timeSlotType , timesCV].forEach { view in
            self.containerView.addSubview(view)
        }
        
        timeSlotType.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        
        timesCV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.timeSlotType.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
extension ProductDetailsDeliveryTimeCell:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlotType.type == .AM ? deliveryTimes?.am()?.count ?? 0 : deliveryTimes?.pm()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
        cell.slot = timeSlotType.type == .AM ? deliveryTimes?.am()?.get(at: indexPath.row) : deliveryTimes?.pm()?.get(at: indexPath.row)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 50) / 2
        return CGSize(width: width, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slot = timeSlotType.type == .AM ? deliveryTimes?.am()?.get(at: indexPath.row) : deliveryTimes?.pm()?.get(at: indexPath.row)
        if slot?.disabled == 1 {return}
        self.delegate?.timeDidSelected(slot: slot)
    }
}
