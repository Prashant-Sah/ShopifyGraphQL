//
//  ProductsCell.swift
//  ShopifyEBPearls
//
//  Created by Prashant Sah on 9/25/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import UIKit
import MobileBuySDK
import SDWebImage

class ProductsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
    }
    
    func configureCell(withProduct product : ProductViewModel ) {//Storefront.Product ) {

        let productImageURL = product.images.first?.url
        if(productImageURL != nil){
            /*
            DispatchQueue.global(qos: .userInteractive ).async {
                let productImageData = NSData(contentsOf: productImageURL!)
                DispatchQueue.main.async {
                    self.productImageView.image = UIImage(data: productImageData! as Data)
                }
            }*/
            productImageView.sd_setImage(with: productImageURL, placeholderImage: nil, options: .scaleDownLargeImages, completed: nil)
        }else{
            self.productImageView.image = #imageLiteral(resourceName: "No_Image_Available")
        }
        
        self.productNameLabel.text = product.title
    }
}
