//
//  CustomRevealViewController.swift
//  ShopifyEBPearls
//
//  Created by Ashim Dhakal on 10/9/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import UIKit
import SWRevealViewController

class CustomRevealViewController: UIViewController, SWRevealViewControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        let revealViewController : SWRevealViewController = self.revealViewController()
        revealViewController.delegate = self
        revealViewController.rearViewRevealOverdraw = 0
        revealViewController.rearViewRevealWidth = 340
    }

    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if (position == FrontViewPosition.left){
            revealController.frontViewController.view.isUserInteractionEnabled = true
        }else{
            revealController.frontViewController.view.isUserInteractionEnabled = true
            revealController.frontViewController.revealViewController().tapGestureRecognizer()
        }
    }
}
