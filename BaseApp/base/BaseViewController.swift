//
//  BaseViewController.swift
//  BaseApp
//
//  Created by Ehab on 13/03/2024.
//

import Foundation
import UIKit
import Combine

protocol BaseView {
    func setup()
    func observers()
    func actions()
}

class BaseViewController: UIViewController , BaseView {
   
    open var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
       // self.view.addGestureRecognizer(ges)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        observers()
        setup()
        actions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    open func setup(){}
    
    open func observers(){}
    
    open func actions(){}
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height + 16
            keyboardOpened(with: keyboardHeight)
        }
    }
    
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardClosed(with: 0)
    }
    open func keyboardOpened(with height:CGFloat){}
    open func keyboardClosed(with height:CGFloat){}
    
    
    func views(_ isLoading:Bool , _ views: UIView...) {
        views.forEach { $0.isUserInteractionEnabled = !isLoading }
    }
       
}
