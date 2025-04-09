//
//  AppFont.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation
import UIKit

enum FontFamily {
    case Inter
    case DINP
}

enum FontWeight {
    case thin
    case extralight
    case light
    case regular
    case semibold
    case medium
    case bold
    case extrabold
    case black
}

public class AppFont: NSObject {
    
    static let shared = AppFont()
    
    func font(family:FontFamily , fontWeight:FontWeight , size:CGFloat) -> UIFont? {
        switch family {
        case .Inter:
            return interFont(fontWeight: fontWeight, size: size)
        case .DINP:
            return dinpFont(fontWeight: fontWeight, size: size)
        }
    }
    
    private func interFont(fontWeight:FontWeight , size:CGFloat) -> UIFont?{
        switch fontWeight {
        case .thin:
            return getFont(name: "Inter-Thin", arName: /*"Tajawal-ExtraLight"*/ "", size: size, weight: .thin)
        case .extralight:
            return getFont(name: "Inter-ExtraLight", arName: /*"Tajawal-ExtraLight"*/ "", size: size, weight: .ultraLight)
        case .light:
            return getFont(name: "Inter-Light", arName: /*"Tajawal-Light"*/ "", size: size, weight: .light)
        case .regular:
            return getFont(name: "Inter-Regular", arName: /*"Tajawal-Regular"*/"", size: size, weight: .regular)
        case .semibold:
            return getFont(name: "Inter24pt-SemiBold", arName: /*"Tajawal-Bold"*/"", size: size, weight: .semibold)
        case .medium:
            return getFont(name: "Inter-Medium", arName: /*"Tajawal-Medium"*/"", size: size, weight: .medium)
        case .bold:
            return getFont(name: "Inter-Bold", arName: /*"Tajawal-Bold"*/"", size: size, weight: .bold)
        case .extrabold:
            return getFont(name: "Inter-ExtraBold", arName: /*"Tajawal-ExtraBold"*/"", size: size, weight: .bold)
        case .black:
            return getFont(name: "Inter-Black", arName: /*"Tajawal-Black"*/"", size: size, weight: .black)
        }
    }
    
    
    private func getFont(name:String, arName:String, size:CGFloat , weight:UIFont.Weight) -> UIFont{
        let font = if AppLanguage.isArabic() {
            UIFont(name: arName , size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        }else {
            UIFont(name: name , size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        }
        return font
    }
    
    
    private func dinpFont(fontWeight:FontWeight , size:CGFloat) -> UIFont?{
        switch fontWeight {
        case .black:
            return UIFont(name: "DINPro-Black", size: size) ?? UIFont.systemFont(ofSize: size, weight: .black)
        case .bold:
            return UIFont(name: "DINPro-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        case .light:
            return UIFont(name: "DINPro-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
        case .medium:
            return UIFont(name: "DINPro-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        default:
            return UIFont.systemFont(ofSize: size)
        }
        
    }

}
