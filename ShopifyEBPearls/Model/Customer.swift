//
//  Customer.swift
//  ShopifyEBPearls
//
//  Created by Ashim Dhakal on 10/9/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import Foundation
import MobileBuySDK

class Customer  {
    
    var firstName : String?
    var lastName : String?
    var displayName : String?
    var email : String
    var phone : String
    var acceptsMarketing : Bool?
    
    var defaultAddress : Storefront.MailingAddress?
    var mailingAddresses : [Storefront.MailingAddressEdge]?
    var orders : [Storefront.OrderEdge]?
    
    var id : String?
    
    init(from model : Storefront.Customer){

        self.firstName = model.firstName
        self.lastName = model.lastName
        self.displayName = model.displayName
        self.email = model.email!
        self.phone = model.phone!
        self.acceptsMarketing = model.acceptsMarketing
        
        self.defaultAddress = model.defaultAddress
        self.mailingAddresses = model.addresses.edges
        self.orders = model.orders.edges
        
    }
    
}
