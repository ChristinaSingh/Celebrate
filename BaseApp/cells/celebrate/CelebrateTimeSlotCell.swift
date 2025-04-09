//
//  TimeSlotCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 10/09/2024.
//

import Foundation
import UIKit
import SnapKit

class CelebrateTimeSlotCell:UITableViewCell {
    
    private let container:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    
    private let timeLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        return lbl
    }()
    
    
    var timeSlot:TimeSlot? {
        didSet{
            self.timeLbl.text = timeSlot?.displaytime
        }
    }
    
    
    var time:PreferredTime? {
        didSet{
            if time?.isSelected == true {
                container.backgroundColor = .accent
                timeLbl.textColor = .white
            }else{
                container.backgroundColor = .white
                timeLbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 1)
            }
            self.timeLbl.text = time?.displaytext
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(container)
        self.container.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        self.container.addSubview(timeLbl)
        self.timeLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
