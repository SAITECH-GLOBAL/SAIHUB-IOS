//
//  SHOCToSwiftUI.swift
//  Saihub
//
//  Created by 周松 on 2022/3/16.
//

import Foundation
import SwiftUI

@objc
class SHOCToSwiftUI: NSObject {
    
    // 跳转到展示二维码
    @objc static func makeDisplayView(text: String, signTransactionBlock: @escaping (() -> Void)) -> UIViewController {
        
        let vc = SHDisplayScenarioViewController(rootView: SHDisplayScenarioView(scenario: text, maxFragmentLen: 200, signTransactionBlock: signTransactionBlock))
        return vc
    }
    
    // 跳转到扫码界面
    @objc static func makeScanView(scanBlock: @escaping ((String) -> Void)) -> UIViewController {
        let vc = SHScanViewController(rootView: SHScanView(scanResult: scanBlock))
        return vc
    }
 }
