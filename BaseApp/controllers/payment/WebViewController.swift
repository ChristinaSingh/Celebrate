//
//  WebViewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 04/09/2024.
//

import Foundation
import UIKit
@preconcurrency
import WebKit
import SnapKit

class WebViewController:UIViewController{
    
    let url:String
    let orderId:String
    let orderDate:String
    let deliveryDate:String
    let total:String
    
    init(url: String, orderId: String, orderDate: String, deliveryDate: String, total: String) {
        self.url = url
        self.orderId = orderId
        self.orderDate = orderDate
        self.deliveryDate = deliveryDate
        self.total = total
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.05)
        return view
    }()
    
    private let headerView:HeaderViewWithCancelButton = {
        let view = HeaderViewWithCancelButton(title: "")
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var webobj:WKWebView = {
        let webobj = WKWebView()
        webobj.backgroundColor = UIColor.clear
        webobj.scrollView.backgroundColor = UIColor.clear
        webobj.uiDelegate = self
        webobj.navigationDelegate = self
        return webobj
    }()
    
    var callback:(() -> ())?
    
    private let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.containerView.addSubview(headerView)
        self.containerView.addSubview(webobj)
        headerView.cancel(vc: self)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        self.webobj.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        self.showActivityIndicatory()
        let encodedStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        if let link = URL(string: encodedStr){
            let request = URLRequest(url: link)
            webobj.load(request)
        }
    }
    
    func showActivityIndicatory() {
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        self.webobj.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
extension WebViewController: WKUIDelegate , WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.absoluteString.contains("https://www.kpay.com.kw/kpg/paymentpage.htm?PaymentID") == true{
            activityView.stopAnimating()
        }
        
        webView.evaluateJavaScript("document.body.innerText") { result, error in
            if let resultString = result as? String,
               resultString.lowercased().contains("Invalid".lowercased()) || resultString.lowercased().contains("Failed".lowercased()) {
                self.openFailPage()
            }
            if let resultString = result as? String,
               resultString.lowercased().contains("Succesfull".lowercased()) {
                self.openSuccessPage()
            }
            
            if let resultString = result as? String,
               resultString.contains("An Error Was Encountered") {
                self.openFailPage()
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    private func openFailPage(){
        self.dismiss(animated: true) {
            self.callback?()
        }
    }
    
    private func openSuccessPage(){
        let vc = PaymentSuccessViewController(orderId: orderId, orderDate: orderDate, deliveryDate: deliveryDate, total: total)
        vc.isModalInPresentation = true
        self.present(vc, animated: false)
    }

    
}
