//
//  ShimmerView.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import UIKit

class ShimmerView: UIView {
    
    var nibName:String
    var customView = UIView()
    
    init(nibName:String) {
        self.nibName = nibName
        super.init(frame: .zero)
        commontInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commontInit(){
        customView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
    }
    
    func showShimmer(vc:UIViewController) {
        vc.view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.customView.subviews.forEach {
                $0.alpha = 0.54
            }
        }, completion: nil)
    }
    
    func hideShimmer(vc:UIViewController) {
        for subview in vc.view.subviews {
            if subview == customView {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    class func getShimmer(name:String) -> UIView {
        return Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as! UIView
    }
    
}
