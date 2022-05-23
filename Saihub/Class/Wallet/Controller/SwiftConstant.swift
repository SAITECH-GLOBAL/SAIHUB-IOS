//
//  SwiftConstant.swift
//  Saihub
//
//  Created by 周松 on 2022/3/17.
//

import Foundation
import UIKit

func GCLocalizedString_swift(key:String) -> String {
    return Bundle.main.localizedString(forKey: key, value: "", table: "Localizable")
}

func kCustomMontserratRegularFont(value: CGFloat) -> UIFont {
    return UIFont.init(name: "Montserrat-Regular", size: value)!
}

func kCustomMontserratMediumFont(value: CGFloat) -> UIFont {
    return UIFont.init(name: "Montserrat-Medium", size: value)!
}
