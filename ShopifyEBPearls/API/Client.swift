//
//  Client.swift
//  New
//
//  Created by Prashant Sah on 9/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import Foundation
import MobileBuySDK

class Client {
    
    static let shopDomain =  "graphql.myshopify.com"   //"ebpearlsteststore.myshopify.com"
    static let apiKey     = "8e2fef6daed4b93cf4e731f580799dd1"  //"b4a297aca4b5a2ff6179fc485aee176a"
    static let merchantID = "merchant.com.your.id"
    
    static let shared = Client()
    
    var client : Graph.Client = Graph.Client(shopDomain: shopDomain, apiKey: apiKey )
    
    private init(){
        self.client.cachePolicy = .networkOnly
    }
    
    
    
    func giveShopName(withquery query : Storefront.QueryRootQuery, completion: @escaping (_ name : String) -> () ) {
        
        let task = client.queryGraphWith(query) { (response, error) in
            
            if let response = response{
                let name = response.shop.name
                completion(name)
            }else{
                if let error = error, case .http(let statusCode) = error{
                    print("Query failed. HTTP error code : \(statusCode)")
                }
            }
        }
        
        task.resume()
    }
    
    
    /// Get collections from the shop ; Products lie inside the collections itself
    ///
    /// - Parameters:
    ///   - query: Query from ClientQuery class, specify limit and cursors in the query method
    ///   - completion: passes collectionModels on completion
    func getCollections(withQuery query : Storefront.QueryRootQuery, completion :  @escaping (_ collectionViewModels : [CollectionViewModel]?, _ collectionPageInfo : PageInfo ) -> () ) {
        
        let task = client.queryGraphWith(query) { (response, error) in
            
            if let response = response  {
                let collectionPageInfo = PageInfo(withPageInfo: (response.shop.collections.pageInfo))
                var collectionViewModels = [CollectionViewModel]()
                
                for collectionEdge in (response.shop.collections.edges) {
                    
                    let collectionModelObject = CollectionViewModel(from: collectionEdge)
                    collectionViewModels.append(collectionModelObject)
                }
                
                completion(collectionViewModels, collectionPageInfo)
                
            }else {
                ErrorHandler.shared.handleQueryErrors(forError : error!)
            }
        }
        task.resume()
    }
    
    
    
    /// Get Products for the collection
    ///
    /// - Parameters:
    ///   - query: Query from ClientQuery class, specify limit and cursors in the query method
    ///   - completion: passes array of ProductViewModel and it's pageInfo on completion
    func getProducts(withQuery query : Storefront.QueryRootQuery, completion :  @escaping (_ productViewModels : [ProductViewModel]?, _ productPageInfo : PageInfo) -> () ){
        
        let task = client.queryGraphWith(query) { (response, error) in
            
            if let response = response{
                
                //let productPageInfo = PageInfo(withPageInfo: response.shop.products.pageInfo)
                var productViewModels = [ProductViewModel]()
                let collection = response.node as? Storefront.Collection
                let productPageInfo = PageInfo(withPageInfo: (collection?.products.pageInfo)!)
                
                for productEdge in (collection?.products.edges)! {
                    let productModelObject = ProductViewModel(from: productEdge)
                    productViewModels.append(productModelObject)
                }
                //let products = response.shop.products.edges.map{ $0.node }
                completion(productViewModels, productPageInfo )
                
            }else{
                ErrorHandler.shared.handleQueryErrors(forError: error!)
            }
        }
        task.resume()
    }
    
    
    
    /// Get details for the product
    /// Generally not required as the product details have already been feteched and stored in the productModel
    /// - Parameters:
    ///   - product: productName as Storefront.Product
    ///   - completion: 
    func getDetailsForProduct (withProduct product : Storefront.Product, completion :  @escaping (_ collections : Storefront.Product) -> () ) {
        
        let query = ClientQuery.queryForProductDetails(withProduct: product)
        let task = client.queryGraphWith(query) { (response, error) in
            if let response = response{
                let product = response.node as? Storefront.Product
                completion(product!)
                
            }else{
                ErrorHandler.shared.handleQueryErrors(forError: error!)

            }
        }
        task.resume()
        
    }
    
    
    
    
    /// Registers a customer with CustomerInfo ; see Customer Info for details
    ///
    /// - Parameters:
    ///   - customerData: Customer Info details
    ///   - completion: gives Storefront.Customer Object
    func createCustomer (withCustomerData customerData: CustomerInfo , completion :  @escaping (_ customer : Storefront.Customer) -> ()   ) {
        
        let input = Storefront.CustomerCreateInput(
            email: customerData.email,
            password:customerData.password,
            firstName: customerData.firstName ,
            lastName: customerData.lastName,
            phone: customerData.phone,
            acceptsMarketing: customerData.acceptsMarketing
        )
        
        
        let mutation = Storefront.buildMutation { $0
            .customerCreate(input: input) { $0
                .customer { $0
                    .id()
                    .email()
                    .firstName()
                    .lastName()
                }
                .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { (response, error) in
            if let mutation = response?.customerCreate{
                
                if let customer = mutation.customer{
                    completion(customer)
                }else{
                    ErrorHandler.shared.handleMutationErrors(forError: mutation.userErrors)
                    mutation.userErrors.forEach({ (error) in
                        print("\(String(describing: error.field))\(error.message)")
                    })
                }
            }
        }
        task.resume()
        
    }
    
    
    
    
    func customerLogin(withInput  customer : CustomerInfo , completion : @escaping (_ token : String) -> () ) {
        
        let input = Storefront.CustomerAccessTokenCreateInput(
            email:    customer.email,
            password: customer.password
        )
        
        let mutation = Storefront.buildMutation { $0
            .customerAccessTokenCreate(input: input) { $0
                .customerAccessToken { $0
                    .accessToken()
                    .expiresAt()
                }
                .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { (response, error) in
            
            if let mutation = response?.customerAccessTokenCreate{
                if let token = mutation.customerAccessToken?.accessToken{
                    completion(token)
                }  else if mutation.userErrors.isEmpty{
                    mutation.userErrors.forEach({ (error) in
                        print("\(String(describing: error.field))\(error.message)")
                    })
                }
            }else{
                print ("Error when logging")
            }
        }
        task.resume()
        
    }
    
}


