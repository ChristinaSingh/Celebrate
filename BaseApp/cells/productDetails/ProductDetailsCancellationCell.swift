//
//  ProductDetailsCancellationCell.swift
//  BaseApp
//
//  Created by Ihab yasser on 03/05/2024.
//

import UIKit
import SnapKit

class ProductDetailsCancellationCell: ProductDetailsCell {

    private let titleLbl:C8Label = {
        let lbl = C8Label()
        lbl.textColor = .black
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.numberOfLines = 0
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()
    
    
    var desc:String?{
        didSet{
            self.titleLbl.text = desc?.trimLeadingSpaces()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.containerView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
//    override func prepareForReuse() {
//        self.titleLbl.text = nil
//    }
}
