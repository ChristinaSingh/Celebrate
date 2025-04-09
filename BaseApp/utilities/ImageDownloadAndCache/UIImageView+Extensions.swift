//
//  UIImageView+Extensions.swift
//  Talent
//
//  Created by Ihab yasser on 05/08/2023.
//

import Foundation
import UIKit

extension UIImageView {
    
    private static var taskKey: UInt8 = 0
    private static var urlKey: UInt8 = 1
    
    private var currentTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var currentImageUrl: String? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.urlKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func download(imagePath: String, size: CGSize, placeholder: UIImage? = nil) {
        currentTask?.cancel()
        self.image = placeholder
        currentImageUrl = imagePath
        if let cachedImage = ImageCacheManager.shared.image(forKey: imagePath) {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: imagePath) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data)/*?.scaleImage(toSize: size)*/ {
                ImageCacheManager.shared.setImage(image, forKey: imagePath)
                DispatchQueue.main.async {
                    if self.currentImageUrl == imagePath {
                        UIView.transition(with: self, duration: 0.75, options: .transitionCrossDissolve, animations: {
                            self.image = image
                        }, completion: nil)
                    }
                }
            }
        }
        
        task.resume()
        currentTask = task
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        _ = UIGraphicsImageRenderer(size: newSize, format: fmt)
        if #available(iOS 17.0, *) {
            let image = UIGraphicsImageRenderer(size: newSize).image { _ in
                draw(in: CGRect(origin: .zero, size: newSize))
            }
            return image.withRenderingMode(renderingMode)
        }else{
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
                context.interpolationQuality = .high
                let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
                context.concatenate(flipVertical)
                context.draw(cgImage, in: newRect)
                if let img = context.makeImage() {
                    newImage = UIImage(cgImage: img)
                }
                UIGraphicsEndImageContext()
            }
            return newImage
        }
    }
}


