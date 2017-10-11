//
//  DSTCoordinator.swift
//  DrawingStyleTransfer
//
//  Created by Torgeir Lien on 11/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import Foundation
import UIKit

class DSTCoordinator {

    var window: UIWindow?
    
    static let sharedInstance = DSTCoordinator()
    private init() {}
    
    func startOfApp () {
        let myViewController = DSTMainVC(nibName: "DSTMainView", bundle: nil)
        window = UIWindow()
        window?.rootViewController = myViewController
        window?.makeKeyAndVisible()
    }
    
}
