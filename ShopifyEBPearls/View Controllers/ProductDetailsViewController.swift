//
//  ProductDetailsViewController.swift
//  ShopifyEBPearls
//
//  Created by Prashant Sah on 9/25/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import UIKit
import WebKit
import MobileBuySDK

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var descriptionWebKitView: WKWebView!
    
    weak var product : ProductViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("Entered ProductDetailsVC")
        self.configureView(withProduct: product!)
        
    }
    
    func configureView(withProduct product : ProductViewModel ) {
        
        let imageData = NSData(contentsOf: (product.images.first?.url)!)
        self.titleImageView.image = UIImage(data: imageData! as Data)
        self.titleImageView.contentMode = .scaleAspectFit
        
        self.titleLabel.text = product.title
        print(product.title)
        
        // WKWebView behaves more like Mobile Safari than a UIWebView does, so you need to set the viewport if you want to control scaling or general sizing.
        let headerString = "<meta name=\"viewport\" content=\"initial-scale=1.0\" /> \n"
        let finalString = headerString + (product.summary)
        self.descriptionWebKitView.loadHTMLString(finalString, baseURL: nil)
        addToCartButton.setTitle("Add To Cart", for: .normal)
        
    }
}






