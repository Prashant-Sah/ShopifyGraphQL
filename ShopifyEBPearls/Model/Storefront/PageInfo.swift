//
//  PageInfo.swift
//  ShopifyEBPearls
//
//  Created by Prashant Sah on 10/5/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import Foundation
import MobileBuySDK

class PageInfo  {
    
    var hasNextPage : Bool?
    //var hasPreviousPage : Bool?
    
    init (withPageInfo pageInfo : Storefront.PageInfo) {
        
        hasNextPage = pageInfo.hasNextPage
        //hasPreviousPage = pageInfo.hasPreviousPage ?? nil
    }
    
}
