//
//  OTPView.swift
//
//
//  Created by Ihab yasser on 12/07/2023.
//

import UIKit
import SnapKit


protocol OTPDidEnteredDelegate {
    func entered(text:String)
    func entering()
}

class OTPView: UIView {
    
    lazy var stack:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.spacing = 8.constraintMultiplierTargetValue.relativeToIphone8Height()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.semanticContentAttribute = .forceLeftToRight
        return stack
    }()
    fileprivate let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
   
    fileprivate var boxes:[UITextField] = []
    
    var keyboardType: UIKeyboardType = .asciiCapableNumberPad{
        didSet{
            setupViews()
        }
    }
    var color:UIColor = .white {
        didSet{
            setupViews()
        }
    }
    
    var isCircle:Bool = false {
        didSet {
            setupViews()
        }
    }
    
    var delegate:OTPDidEnteredDelegate?
    var text:String?{
        get{
            return enteredValues()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.semanticContentAttribute = .forceLeftToRight
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear(){
        boxes.forEachIndexed { index, _ in
            self.boxes[safe: index]?.text = ""
        }
    }

    fileprivate func setupViews(isStoryboard:Bool = false){
      
        boxes.removeAll()
        for _ in 1...6 {
            boxes.append(createBox())
        }
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stack.removeFullyAllArrangedSubviews()
        for (index , box) in boxes.enumerated() {
            box.tag = index + 1
            stack.addArrangedSubview(box)
            if isCircle {
                box.layer.cornerRadius = 28.constraintMultiplierTargetValue.relativeToIphone8Height()
                box.layer.borderWidth = 1
                box.layer.borderColor = color.withAlphaComponent(0.1).cgColor
                box.snp.makeConstraints { make in
                    make.width.equalTo(56.constraintMultiplierTargetValue.relativeToIphone8Height())
                    make.top.bottom.equalToSuperview()
                }
            }else{
                box.snp.makeConstraints { make in
                    make.width.equalTo(30)
                    make.top.bottom.equalToSuperview()
                }
            }
            
        }
    }
    
    
    func requestFocus() {
        if boxes.count > 0 {
            self.boxes.first?.becomeFirstResponder()
        }
    }

    
    
    fileprivate func createBox() -> Box{
        let box = Box(frame: .zero)
        box.isUserInteractionEnabled = true
        box.layer.masksToBounds = true
        box.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 32)
        box.textColor = color
        box.tintColor = color
        box.textAlignment = .center
        if !isCircle {
            box.attributedPlaceholder = NSAttributedString(
                string: "●",
                attributes: [NSAttributedString.Key.foregroundColor: self.color.withAlphaComponent(0.3) , NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]
                )
        }
        box.delegate = self
        box.textContentType = .oneTimeCode
        box.keyboardType = keyboardType
        return box
    }
    
    
   
    
    fileprivate func enteredValues() -> String{
        var text = ""
        for box in boxes {
            text += box.text ?? ""
        }
        return text
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override var intrinsicContentSize: CGSize {
            return stack.intrinsicContentSize
        }
    
}

extension OTPView : UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if text?.count ?? 0 >= 6 {
            boxes.last?.becomeFirstResponder()
        }else if text?.isEmpty == true{
            boxes.first?.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let box = textField as? Box else { return false }
        
        // Only allow acceptable characters
        let filtered = string.filter { ACCEPTABLE_CHARACTERS.contains($0) }
        guard string == filtered else { return false }
        
        // Handle insertion and deletion
        if !string.isEmpty {
            box.text = string.uppercased()
            if let nextBox = boxes.first(where: { !$0.hasText }) {
                nextBox.becomeFirstResponder()
            } else {
                delegate?.entered(text: enteredValues())
                box.resignFirstResponder()
            }
        } else {
            // Handle delete/backspace
            box.text = ""
            if let prevBox = viewWithTag(box.tag - 1) as? Box {
                prevBox.becomeFirstResponder()
            }
        }
        
        delegate?.entering()
        return false
    }
    
}

class Box:UITextField {
    
//    override func layoutSubviews() {
//        textAlignment = .center
//        attributedPlaceholder = NSAttributedString(
//            string: "0",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
//            )
//    }
    
    override func deleteBackward() {
        super.deleteBackward()
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "")
    }
//    
}
extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}
