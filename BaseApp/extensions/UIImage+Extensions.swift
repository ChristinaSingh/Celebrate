//
//  UIImage+Extensions.swift
//  BaseApp
//
//  Created by Ihab yasser on 11/04/2024.
//

import Foundation
import UIKit


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
