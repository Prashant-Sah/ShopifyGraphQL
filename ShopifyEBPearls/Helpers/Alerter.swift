//
//  Alerter.swift
//  ShopifyEBPearls
//
//  Created by Ashim Dhakal on 10/6/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController

class Alerter {
    
    static let shared = Alerter()
    
    func createAlert(withTitle title : String , andMessage message : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let alertAction = UIAlertAction(title: "OK" , style: .default , handler: nil)
        
        alertController.addAction(alertAction)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }else{
            rootViewController = rootViewController?.presentedViewController
        }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
