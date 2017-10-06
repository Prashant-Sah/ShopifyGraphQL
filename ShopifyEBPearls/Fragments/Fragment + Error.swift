//
//  Fragment + Error.swift
//  ShopifyEBPearls
//
//  Created by Prashant Sah on 10/6/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import Foundation
import MobileBuySDK

class Errors {
    
    static let shared = Errors()
    
    func handleQueryErrors(forError error : Graph.QueryError )  {
        
        switch(error) {
        case .request(let error):
            print("Non HTTPURL response was received. \(error.debugDescription)")
            break
        case .http(let statusCode):
            print("HTTP error with code: \(statusCode)")
            break
        case .noData:
            print("The response contains no data")
            break
        case .jsonDeserializationFailed(let data):
            print("JSON deserialization failed, invalid syntax\\n")
            print(data!)
            break
        case .invalidJson(let json):
            print("JSON structure doesn't match expression")
            print(json)
            break
        case .invalidQuery(let reasons):
            print("The provided query was partially or completely invalid \\n")
            for reason in reasons {
                print(reason.message,"\n")
            }
            break
        case .schemaViolation(let violation):
            print ("The response schema does not match expectation")
            print(violation.localizedDescription)
            break
        }
    }
    
    func handleMutationErrors(forError errors : [Storefront.UserError] ) {
        
        for userError in errors {
            print(userError.message)
        }
    }
}
