//
//  LoadingVendorsFooter.swift
//  BaseApp
//
//  Created by Ihab yasser on 04/05/2024.
//

import UIKit
import SnapKit

class LoadingTVFooter: UIView {

    let loadingIndicator:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .medium)
        loading.color = UIColor(named: "AccentColor")
        loading.hidesWhenStopped = true
        loading.stopAnimating()
        return loading
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
