//
//  PlanEventUserNameViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 18/09/2024.
//

import Foundation
import UIKit
import SnapKit

class PlanEventUserNameViewController: CelebrantNameViewController {
    
    var service: Service
    var body:PlanEventBody
    internal init(service: Service, body:PlanEventBody) {
        self.service = service
        self.body = body
        super.init(area: nil, day: nil, time: nil, occasions: [])
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLbl.text = "Enter your full name".localized
        titleLbl.text = "Organize event".localized
        
        proceedBtn.tap = {
            self.body.fullName = self.input.text
            let vc = PlanEventOccasionViewController(body: self.body, service: self.service)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
