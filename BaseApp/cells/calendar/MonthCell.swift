//
//  MonthCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import UIKit
import SnapKit

class MonthCell: UICollectionViewCell {
    
    private let contentBg:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var daysCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.layer.cornerRadius = 8
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return cv
    }()
    
    
    var days:[Day] = []{
        didSet{
            self.daysCV.reloadData()
        }
    }
    
    var callback:((Day?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.contentView.addSubview(contentBg)
        self.contentBg.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        contentBg.addSubview(daysCV)
        daysCV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
extension MonthCell:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.day = days[safe: indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 50) / 2
        return CGSize(width: width, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDateLessThanTodayIgnoringTime(date: days[safe: indexPath.row]?.date ?? Date()) {
            ToastBanner.shared.show(message: "Can't select past date", style: .info , position: .Top)
        }else{
            callback?(self.days[safe: indexPath.row])
        }
       
    }
    
    func isDateLessThanTodayIgnoringTime(date: Date) -> Bool {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let dateStart = calendar.startOfDay(for: date)
        return dateStart < todayStart
    }
}
