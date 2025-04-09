//
//  ViewEmbedder.swift
//  BaseApp
//
//  Created by Ihab yasser on 06/06/2024.
//

import Foundation
import UIKit


open class ViewEmbedder {
    
    open class func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
            
            if let previous = previous {
                removeFromParent(vc: previous)
            }
            child.willMove(toParent: parent)
            parent.addChild(child)
            container.addSubview(child.view)
            child.didMove(toParent: parent)
            let w = container.frame.size.width;
            let h = container.frame.size.height;
            child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
        }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    open class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: parent.children.first
        )
        completion?(vc)
    }
    
}
