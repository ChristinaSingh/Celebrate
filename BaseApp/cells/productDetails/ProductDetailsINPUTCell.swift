//
//  ProductDetailsINPUTCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit

class ProductDetailsINPUTCell: ProductDetailsCell , UITextViewDelegate {
    
    
    var isFirst:Bool = false{
        didSet{
            if isFirst && !isLastCell {
                self.containerView.layer.cornerRadius = 8
                self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
            }else if isFirst && isLastCell {
                self.containerView.layer.cornerRadius = 8
                self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
            } else{
                self.containerView.layer.cornerRadius = 0
            }
        }
    }
    
    var option : Option? {
        didSet{
            guard let option = option else {return}
            self.titleLbl.text = AppLanguage.isArabic() ? option.arName : option.name
            self.input.text = option.inputText
        }
    }

    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    
    lazy private var input: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isScrollEnabled = true
        textView.delegate = self
        return textView
    }()
    
    
    lazy private var requiredView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.layer.cornerRadius = 12
        view.addSubview(requiredLbl)
        requiredLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    private let requiredLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        lbl.textColor = .white
        lbl.text = "Required".localized
        return lbl
    }()
    
    var isRequired:Bool?{
        didSet {
            guard let isRequired else {return}
            self.requiredView.isHidden = !isRequired
            requiredView.snp.remakeConstraints { make in
                make.centerY.equalTo(self.titleLbl.snp.centerY)
                make.trailing.equalToSuperview().offset(-16)
                make.width.equalTo(isRequired ? 67 :0)
                make.height.equalTo(24)
            }
        }
    }
    
    var textChanged:((String) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        [titleLbl , input, requiredView].forEach { view in
            self.containerView.addSubview(view)
        }

        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        requiredView.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(0)
            make.height.equalTo(24)
        }
        
        input.snp.makeConstraints { make in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textChanged?(textView.text)
    }
}
