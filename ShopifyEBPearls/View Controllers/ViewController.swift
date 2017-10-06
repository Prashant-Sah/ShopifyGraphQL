//
//  ViewController.swift
//  New
//
//  Created by Prashant Sah on 9/14/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import MobileBuySDK

class ViewController: UIViewController {
    
    var lastCollectionCursor : String? = nil
    var hasNextCollectionPage : Bool = false
    var collectionsCount : Int = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    lazy var collectionsArray = [CollectionViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCollectionsToArray()
        
        self.myTableView?.dataSource = self
        self.myTableView?.delegate = self
        self.myTableView?.register(UINib(nibName: "CollectionCell", bundle: nil ), forCellReuseIdentifier: "Cell")
        
        Client.shared.giveShopName(withquery: ClientQuery.queryForShopName()) { (name) in
            print ("Name of Shop: \(name)")
        }
    }
}

extension ViewController {
    
    func loadCollectionsToArray () {
        
        Client.shared.getCollectionsAndProducts(withQuery: ClientQuery.queryForCollections(limit: 10, after: nil, productLimit: 5, productCursor: nil)) { (collectionViewModels, pageInfo) in
            
            if let obtainedCollectionModels = collectionViewModels {
                
                self.collectionsArray = obtainedCollectionModels
                self.collectionsCount = obtainedCollectionModels.count
                self.hasNextCollectionPage = pageInfo.hasNextPage!
                
                for collection in obtainedCollectionModels{
                    print (collection.title)
                    
                    for product in collection.products {
                        print ("\t\(product.title)")
                    }
                }
                self.myTableView.reloadData()
            }
        }
    }
}





//MARK- UITableViewDataSource functions
extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return collectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // ----------------------------------
    //  MARK: - Titles -
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.collectionsArray[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let width  = UIScreen.main.bounds.width
        let height = width * 0.75 // 3:4 ratio
        return height + 150.0 // 150 is the height of the productCollectionView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = myTableView?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CollectionCell{
            cell.delegate = self
            cell.configureCell(withCollection: collectionsArray[indexPath.section])
            return cell
        }else{
            return CollectionCell()
        }
    }
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
        productsVC?.configureView(withCollection: collectionsArray[indexPath.section])
        self.navigationController?.pushViewController(productsVC!, animated: true)
    }
}

extension ViewController : CollectionCellProtocol {
    
    func didEndedScrolling(forCollection collection: CollectionViewModel, withLastProductCursor lastProductCursor: String) {
        
        if let index = collectionsArray.index(where: { $0.id == collection.id } ) {
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                Client.shared.getProducts(withQuery: ClientQuery.queryForProducts(in: collection, limit: 5, after: lastProductCursor), completion: { (productViewModels, productPageInfo ) in
                    
                    for productViewModel in productViewModels! {
                        self.collectionsArray[index].products.append(productViewModel)
                    }
                    self.collectionsArray[index].productsPageInfo = productPageInfo

                    let indexSet = IndexSet(integer: index)
                    DispatchQueue.main.async {
                        self.myTableView.reloadSections(indexSet, with: UITableViewRowAnimation.none)
                    }
                })
            }
        }
    }
    
    func didSelectCell(withProduct product: ProductViewModel) {
        
        let productDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController
        print ("Selected a collection view cell inside table view cell")
        productDetailsVC?.product = product
        self.navigationController?.pushViewController(productDetailsVC!, animated: true)
    }
    
}



extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        
        if (endScrolling >= scrollView.contentSize.height && hasNextCollectionPage ){
            
                loadCollectionsToArray()
            
        }
    }
}



/*
 let customerData = CustomerInfo(email: "prashantsah@gmail.com", password: "12345")
 Client.shared.createCustomer(withCustomerData: customerData) { (customer) in
 print(customer.email!)
 print(customer.firstName ?? nil)
 }
 
 Client.shared.customerLogin(withInput: customerData) { (token) in
 print("Login Successfull")
 UserDefaults.standard.set(token, forKey: "UserAccessToken")
 }
 */
