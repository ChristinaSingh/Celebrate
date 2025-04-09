//
//  CelebrateBudgetViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/09/2024.
//

import UIKit
import SnapKit

class CelebrateBudgetViewController: BaseViewController {
    
    private let area:Area?
    private let day:Day?
    private let time:TimeSlot?
    private let occasions:[CelebrateOcassion]
    private let categories:[Category]
    private let subcategories:String?
    private let service:Service
    private let inputs:[Input]
    private let prices:CelebrateAvaragePrice?
    private var body:PlanEventBody
    
    init(area: Area?, day: Day?, time: TimeSlot?, occasions: [CelebrateOcassion], categories: [Category],subcategories:String, inputs:[Input], prices:CelebrateAvaragePrice?) {
        self.area = area
        self.day = day
        self.time = time
        self.occasions = occasions
        self.categories = categories
        self.subcategories = subcategories
        self.service = .none
        self.inputs = inputs
        self.prices = prices
        self.body = PlanEventBody()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    init (service: Service, body:PlanEventBody) {
        self.area = nil
        self.day = nil
        self.time = nil
        self.occasions = []
        self.categories = []
        self.body = body
        self.service = service
        self.inputs = []
        self.prices = nil
        self.subcategories = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView:HeaderView = {
        let view = HeaderView(title: "Organize event".localized)
        view.backgroundColor = .white
        view.withSearchBtn = false
        view.separator.isHidden = true
        return view
    }()
    
    private let messageLbl:C8Label = {
        let lbl = C8Label()
        lbl.text = "Enter your budget".localized
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .semibold, size: 22)
        return lbl
    }()
    
    
    private let hintLbl:C8Label = {
        let lbl = C8Label()
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.textColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.5)
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 12)
        return lbl
    }()
    
    
    lazy private var budgetSliderView:UISlider = {
        let slider = UISlider()
        slider.minimumValue = prices?.data?.minAvgprice ?? 0
        slider.maximumValue = 10000
        slider.tintColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1)
        return slider
    }()
    
    private let kdLbl:C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        lbl.textColor = .black
        lbl.text = "kd".localized
        return lbl
    }()
    
    
    lazy private var budgetTF:UITextField = {
        let textField = UITextField()
        textField.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        textField.textColor = .black
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.isUserInteractionEnabled = false
        textField.text = "\(Double(prices?.data?.minAvgprice ?? 0).clean)"
        return textField
    }()
    
    lazy private var stackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: AppLanguage.isArabic() ? [budgetTF, kdLbl] : [budgetTF, kdLbl])
        stack.spacing = 4
        return stack
    }()

    
    lazy var proceedBtn:LoadingButton = {
        let btn = LoadingButton.createObject(title: "Proceed".localized, width: self.view.frame.width - CGFloat(32), height: 48.constraintMultiplierTargetValue.relativeToIphone8Height())
        btn.enableDisableSaveButton(isEnable: true)
        btn.setActive(true)
        btn.loadingView.color = .white
        btn.loadingView.backgroundColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.hintLbl.text = "\("A minimum budget of".localized) \(Double(prices?.data?.minAvgprice ?? 0).clean) \("is required to proceed".localized)"
        headerView.back(vc: self)
        [headerView, messageLbl, budgetSliderView, stackView, hintLbl, proceedBtn].forEach { view in
            self.view.addSubview(view)
        }
        stackView.semanticContentAttribute = AppLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        budgetSliderView.setThumbImage(self.designThumbView().toUIImage(), for: .normal)
       
        
        proceedBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-53.constraintMultiplierTargetValue.relativeToIphone8Height())
            make.height.equalTo(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(98)
        }
        
        messageLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(48.constraintMultiplierTargetValue.relativeToIphone8Height())
        }
        
        budgetSliderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(self.messageLbl.snp.bottom).offset(56)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.budgetSliderView.snp.bottom).offset(34)
        }
        
        hintLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.stackView.snp.bottom).offset(48)
        }
        
        proceedBtn.tap = {
            if self.service == .PlanEvent {
                let vc = EventNoOffGuestsViewController(service: self.service, body: self.body)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = BundlesViewController(area: self.area, day: self.day, time: self.time, occasions: self.occasions, categories: self.categories, subcategories: self.subcategories ?? "", budget: self.budgetTF.text ?? "", inputs: self.inputs)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        budgetSliderView.addTarget(self, action: #selector(budgetChanged(_:)), for: .valueChanged)
    }
    
    override func keyboardOpened(with height: CGFloat) {
        proceedBtn.snp.updateConstraints { make in
            make.bottom.equalTo(-height)
        }
    }
    
    override func keyboardClosed(with height: CGFloat) {
        proceedBtn.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-53)
        }
    }
    
    
    @objc private func budgetChanged(_ slider:UISlider){
        self.budgetTF.text = "\(Double(slider.value).clean)"
        self.proceedBtn.enableDisableSaveButton(isEnable: true)
    }
    
    private func designThumbView() -> UIView{
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 36))
        let thumbCircleView = CardView(frame: CGRect(x: 4, y: 4, width: 24, height: 24))
        let whiteCircleView = UIView(frame: CGRect(x: 12, y: 12, width: 8, height: 8))
        whiteCircleView.backgroundColor = .white
        whiteCircleView.layer.cornerRadius = 4
        whiteCircleView.clipsToBounds = true
        thumbCircleView.backgroundColor = .accent
        thumbCircleView.clipsToBounds = true
        thumbCircleView.shadowOffsetWidth = 0
        thumbCircleView.shadowOffsetHeight = 4
        thumbCircleView.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        thumbCircleView.shadowOpacity = 1
        thumbCircleView.cornerRadius = 12
        thumbView.addSubview(thumbCircleView)
        thumbView.addSubview(whiteCircleView)
        return thumbView
    }
    
}
extension CelebrateBudgetViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        if let number = Int(updatedText), number > 10000 {
            return false
        }
        self.proceedBtn.enableDisableSaveButton(isEnable: updatedText.isBlank == false)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let number = Float(text) {
            if number <= 10000 && number >= 100 {
                self.budgetSliderView.value = number
            } else if number < 100{
                self.budgetTF.text = "100"
                self.budgetSliderView.value = 100
            }
        }else{
            self.budgetTF.text = "100"
            self.budgetSliderView.value = 100
        }
        self.proceedBtn.enableDisableSaveButton(isEnable: true)
    }
}
