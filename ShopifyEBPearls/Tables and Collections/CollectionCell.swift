//
//  CollectionCell.swift
//  ShopifyEBPearls
//
//  Created by Prashant Sah on 9/21/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import UIKit
import MobileBuySDK

protocol CollectionCellProtocol : class {
    
    func didSelectCell( withProduct product : ProductViewModel )
    
    func didEndedScrolling(forCollection collection : CollectionViewModel, withLastProductCursor lastProductCursor : String)
}


class CollectionCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    weak var delegate : CollectionCellProtocol?
    
    lazy var products = [ProductViewModel]()
    var hasNextProductPage : Bool?
    lazy var lastProductCursor = String()
    var theCollection : CollectionViewModel?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        self.myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    @discardableResult
    
    func configureCell (withCollection collection : CollectionViewModel ) -> [ProductViewModel] {
        
        theCollection = collection
        products = collection.products
        lastProductCursor = (products.last?.cursor)!
        hasNextProductPage = collection.productsPageInfo?.hasNextPage
        
        if(collection.imageURL != nil){
            self.mainImageView.sd_setImage(with: collection.imageURL, placeholderImage: #imageLiteral(resourceName: "No_Image_Available") , options: .scaleDownLargeImages , completed: nil)
        }
        
        print ("No. of products: \(String(describing: products.count))")
        self.myCollectionView.reloadData()
        return collection.products
    }
}



// -----------------------------------------------
//  MARK: - UICollectionViewDelegateFlowLayout -
//
extension CollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let length = collectionView.bounds.height - layout.sectionInset.top - layout.sectionInset.bottom
        return CGSize(
            width:  length,
            height: length
        )
    }
}


extension CollectionCell : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.products.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let productImageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: myCollectionView.frame.size.height))
        productImageView.sd_setImage(with: products[indexPath.row].images.first?.url, placeholderImage: nil, options: .scaleDownLargeImages, completed: nil)
        cell.contentView.addSubview(productImageView)
        productImageView.contentMode = .scaleAspectFit
        
        return cell
        
    }
}


extension CollectionCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("selected collectionview cell inside tableviewcell")
        self.delegate?.didSelectCell(withProduct: products[indexPath.row])
    }
}

extension CollectionCell : UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let endScrolling = scrollView.contentOffset.x + scrollView.frame.size.width;
        
        if (endScrolling >= scrollView.contentSize.width && hasNextProductPage! ){
            
            self.delegate?.didEndedScrolling(forCollection: theCollection!, withLastProductCursor : lastProductCursor )
        }
    }
}

