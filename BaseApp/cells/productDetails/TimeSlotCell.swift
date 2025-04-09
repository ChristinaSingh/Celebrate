//
//  TimeSlotCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/05/2024.
//

import UIKit
import SnapKit

class TimeSlotCell: UICollectionViewCell {
    
    
    private let contentBg:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let dateLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return lbl
    }()
    
    
    private let timeLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 17)
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    
    var slot:Slot? {
        didSet{
            guard let slot = slot else {return}
            timeLbl.text = "\(slot.startTime?.formatTime()?.hours ?? "") - \(slot.endTime?.formatTime()?.hours ?? "") \(slot.endTime?.formatTime()?.amPm ?? "")"
            dateLbl.text = OcassionDate.shared.getDate()?.timeSlotFormatedDate()
            if slot.isSelected {
                dateLbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                timeLbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                contentBg.backgroundColor = .accent
            }else{
                dateLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                timeLbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                contentBg.backgroundColor = .white
            }
            contentBg.alpha = slot.disabled == 1 ? 0.5 : 1
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
        [dateLbl , timeLbl].forEach { view in
            self.contentBg.addSubview(view)
        }
        
        dateLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        timeLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.dateLbl.snp.bottom).offset(4)
        }
    }
}
