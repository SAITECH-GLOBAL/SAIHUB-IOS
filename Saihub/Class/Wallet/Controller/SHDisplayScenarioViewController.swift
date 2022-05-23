//
//  SHDisplayScenarioViewController.swift
//  Saihub
//
//  Created by 周松 on 2022/3/16.
//

import Foundation
import SwiftUI

class SHDisplayScenarioViewController: UIHostingController<SHDisplayScenarioView> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }

    }

}
