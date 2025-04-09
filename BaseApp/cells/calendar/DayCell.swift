//
//  DayCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 12/04/2024.
//

import UIKit
import SnapKit

class DayCell: UICollectionViewCell {
    
    
    let contentBg:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    private let dayNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    
    private let dayLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 40)
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    private let monthNameLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    var day:Day?{
        didSet{
            guard let day = day else {return}
            monthNameLbl.text = day.month
            dayLbl.text = day.number
            if day.isToday {
                dayNameLbl.text = "\(day.dayName) • Today"
            }else{
                dayNameLbl.text = day.dayName
            }
            if day.isSelected {
                contentBg.backgroundColor = UIColor(named: "AccentColor")
                contentBg.layer.borderWidth = 0
                dayLbl.textColor = .white
                dayNameLbl.textColor = .white
                monthNameLbl.textColor = .white.withAlphaComponent(0.5)
            }else{
                contentBg.backgroundColor = isDateLessThanTodayIgnoringTime(date: day.date) ? .black.withAlphaComponent(0.06) : .white
                contentBg.layer.borderWidth = 1
                dayLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                dayNameLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                monthNameLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.contentView.addSubview(contentBg)
        contentBg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [dayNameLbl , dayLbl , monthNameLbl].forEach { view in
            self.contentBg.addSubview(view)
        }
        
        dayNameLbl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        dayLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.dayNameLbl.snp.bottom)
            make.height.equalTo(48)
        }
        
        monthNameLbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.dayLbl.snp.bottom)
            make.height.equalTo(18)
        }
    }
    
    func isDateLessThanTodayIgnoringTime(date: Date) -> Bool {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let dateStart = calendar.startOfDay(for: date)
        return dateStart < todayStart
    }
}

