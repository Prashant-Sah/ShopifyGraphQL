//
//  SignUpViewController.swift
//  ShopifyEBPearls
//
//  Created by Ashim Dhakal on 10/9/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import UIKit
import MobileBuySDK

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var ImageSelectButton : UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var acceptsMarketingButton: UIButton!
    
    var customerParams = [String : String ]()
    var acceptsMarketing : Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        
        self.ImageSelectButton.layer.cornerRadius = self.ImageSelectButton.frame.size.width/2
        
    }
    
}

// MARK:  Button Handlers
extension SignUpViewController {
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func acceptMarketing(_ sender : UIButton) {
        
        acceptsMarketing = !acceptsMarketing
        if(acceptsMarketing){
            self.acceptsMarketingButton.setImage(#imageLiteral(resourceName: "avatar"), for: .normal)
        }else{
            self.acceptsMarketingButton.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        
        if (self.emailTextField.text != nil && self.passwordTextField.text != nil){
            
            let customerData = CustomerInfo(email: self.emailTextField.text! , password: self.passwordTextField.text! , firstName: self.firstNameTextField.text ?? "" , lastName: self.lastNameTextField.text ?? "", phone: self.phoneTextField.text! , acceptsMarketing: self.acceptsMarketing )
            //(self.phoneTextField.text == "") ? nil : self.phoneTextField.text
            Client.shared.createCustomer(withCustomerData: customerData) { (customer) in
                
                print(customer)
            }
        }
    }
    
    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender : UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

