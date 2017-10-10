//
//  SideBarViewController.swift
//  ShopifyEBPearls
//
//  Created by Ashim Dhakal on 10/9/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        let navVC = UINavigationController(rootViewController: signUpVC!)
        self.present(navVC, animated: true , completion: nil)
        
        
    }
    
}
