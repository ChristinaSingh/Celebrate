//
//  CalendarViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import UIKit
import SnapKit

protocol DaySelectionDelegate {
    func dayDidSelected(day: Day?)
    func timeDidSelected(time: PreferredTime?)
}

class CalendarViewController: UIViewController {
    
    
    private lazy var monthsCV:UICollectionView = {
        let layout = AppLanguage.isArabic() ? RTLCollectionViewFlowLayout() : UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(MonthTitleCell.self, forCellWithReuseIdentifier: "MonthTitleCell")
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.allowsSelection = true
        return cv
    }()
    
    
    private lazy var monthCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.register(MonthCell.self, forCellWithReuseIdentifier: "MonthCell")
        cv.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = .zero
        return cv
    }()
    
    private let line:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return view
    }()
    
    
    private let cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel".localized, for: .normal)
        btn.setTitleColor(UIColor(named: "SecondaryColor"), for: .normal)
        btn.titleLabel?.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 14)
        return btn
    }()
    
    
    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Event date".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    private lazy var months:[Month] = CalendarManager.shared.getMonths(start: self.startDate, count: 12, selectedDate: self.selectedDate)
    
    var delegate:DaySelectionDelegate?
    var areaDelegate:AreaSelectionDelegate?
    var selectedDate:Date?
    var startDate:Date = Date()
    var cartType:CartType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        actions()
        self.months.forEachIndexed { m, month in
            self.months[safe: m]?.days = month.days.filter { day in
                return self.isSameDateIgnoringTime(day.date, self.startDate)
            }
        }
    }
    
    func isSameDateIgnoringTime(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay1 = calendar.startOfDay(for: date1)
        let startOfDay2 = calendar.startOfDay(for: date2)
        return startOfDay1 >= startOfDay2
    }


    func setup() {
        self.view.backgroundColor = .white
        [titleLbl , cancelBtn , monthsCV, line , monthCV].forEach { view in
            self.view.addSubview(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
            make.height.equalTo(22)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.titleLbl.snp.centerY)
        }
        
        monthsCV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLbl.snp.bottom).offset(11)
            make.height.equalTo(45)
        }
        
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(self.monthsCV.snp.bottom)
        }
        
        monthCV.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.line.snp.bottom)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let selectedDate = self.selectedDate {
            if let index = self.months.firstIndex(where: { month in
                month.days.isEmpty == false && month.days.first(where: { day in
                    day.date == selectedDate
                }) != nil
            }){
                self.scrollToIndex(index: index)
            }else{
                self.scrollToIndex(index: 0)
            }
        }else{
            self.scrollToIndex(index: 0)
        }
    }
    
    
    private func scrollToIndex(index:Int){
        self.months[safe:index]?.isSelected = true
        self.monthsCV.reloadData()
        self.monthCV.reloadData()
        let workItem = DispatchWorkItem(qos: .userInteractive) {
            self.monthsCV.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
            self.monthCV.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
    }
    
    func actions() {
        cancelBtn.tap {
            if self.cartType == .normal {
                if OcassionDate.shared.getEventDate() == nil {
                    ToastBanner.shared.show(message: "Please select an event date.".localized, style: .info, position: .Top)
                    return
                }
                if OcassionLocation.shared.getArea() == nil {
                    ToastBanner.shared.show(message: "Please select an area.".localized, style: .info, position: .Top)
                    return
                }
                self.dismiss(animated: true)
            }else{
                self.dismiss(animated: true)
            }
        }
    }
    
    class func show(on viewController: UIViewController, cartType:CartType, selectedDate:Date? = nil, startDate:Date = Date(), delegate:DaySelectionDelegate? = nil, areaDelegate:AreaSelectionDelegate? = nil) {
        let vc = CalendarViewController()
        vc.isModalInPresentation = true
        vc.delegate = delegate
        vc.areaDelegate = areaDelegate
        vc.selectedDate = selectedDate
        vc.startDate = startDate
        vc.cartType = cartType
//        if areaDelegate != nil {
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            viewController.present(nav, animated: true)
//        }else{
//            viewController.present(vc, animated: true)
//        }
    }

}
extension CalendarViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == monthsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthTitleCell", for: indexPath) as! MonthTitleCell
            cell.month = months[safe: indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell
            cell.days = months[safe: indexPath.row]?.days ?? []
            cell.callback = { day in
                if self.areaDelegate != nil {
                    self.delegate?.dayDidSelected(day: day)
                    self.navigationController?.pushViewController(AreasViewController(delegate: self.areaDelegate, timeDelegate: self.delegate, cartType: self.cartType), animated: true)
                }else{
                    if self.cartType == .normal {
                        self.delegate?.dayDidSelected(day: day)
                        self.navigationController?.pushViewController(DeliveryTimeViewController(delegate: self.delegate), animated: true)
                    }else{
                        self.dismiss(animated: true) {
                            self.delegate?.dayDidSelected(day: day)
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == monthsCV {
            let data = months[safe: indexPath.row]?.monthName
            let font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
            let labelSize = (data as? NSString)?.size(withAttributes: [NSAttributedString.Key.font: font])
            let width = labelSize?.width
            return CGSize(width: width ?? 0, height: 45)
            
        }else{
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == monthsCV {
            return 24
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == monthsCV {
            self.resetMonths()
            self.months[safe: indexPath.row]?.isSelected = true
            self.monthsCV.reloadData()
            self.monthsCV.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            self.monthCV.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == monthCV {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            self.resetMonths()
            self.months[currentPage].isSelected = true
            self.monthsCV.reloadData()
            self.monthsCV.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    
    func resetMonths() {
        for (index , _) in months.enumerated() {
            months[index].isSelected = false
        }
    }
}
