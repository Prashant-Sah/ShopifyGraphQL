//
//  ProductViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
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

final class ProductViewModel {
    
    let cursor:   String
    
    var id:       String
    var title:    String
    var summary:  String
    var price:    Decimal
    var images =   [ImageViewModel]()
    var variants = [VariantViewModel]()
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: Storefront.ProductEdge) {
        
        self.cursor   = model.cursor
        
        self.id       = model.node.id.rawValue
        self.title    = model.node.title
        self.summary  = model.node.descriptionHtml
        //self.price    = lowestPrice == nil ? "No price" : Currency.stringFrom(lowestPrice!)
        
        for imageEdge in model.node.images.edges {
            let imageModelObject = ImageViewModel(from: imageEdge)
            self.images.append(imageModelObject)
        }
        
        for variantEdge in model.node.variants.edges {
            let variantModelObject = VariantViewModel(from: variantEdge)
            variants.append(variantModelObject)
        }
        
        variants = variants.sorted { $0.price > $1.price }
        self.price = (variants.first?.price)!
        
    }
}

