//
//  SHScanViewController.swift
//  Saihub
//
//  Created by 周松 on 2022/3/14.
//

import Foundation
import SwiftUI

@objcMembers class SHScanViewController: UIHostingController<SHScanView> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }

    }
            
}
