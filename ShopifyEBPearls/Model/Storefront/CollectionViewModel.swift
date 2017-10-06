//
//  CollectionViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software isdfgdtbfg
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import MobileBuySDK

class CollectionViewModel {
    
    var cursor:      String
    
    var id:          String
    var title:       String
    var description: String
    var imageURL:    URL?
    var products = [ProductViewModel]()
    
    var productsPageInfo : PageInfo?
    // ----------------------------------
    //  MARK: - Init -
    //
    
    init(from model: Storefront.CollectionEdge) {
        
        self.cursor      = model.cursor
        
        self.id          = model.node.id.rawValue
        self.title       = model.node.title
        self.imageURL    = model.node.image?.src
        self.description = model.node.descriptionHtml
        
        self.productsPageInfo = PageInfo(withPageInfo: model.node.products.pageInfo)
        
        for productEdge in model.node.products.edges {
            let productModelObject = ProductViewModel(from: productEdge)
            self.products.append(productModelObject)
        }
        
    }
}
