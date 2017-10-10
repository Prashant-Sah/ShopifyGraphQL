//
//  ErrorHandler.swift
//  ShopifyEBPearls
//
//  Created by Prashant Sah on 10/6/17.
//  Copyright © 2017 EBPearls. All rights reserved.
//

import Foundation
import MobileBuySDK

class ErrorHandler {
    
    static let shared = ErrorHandler()
    
    func handleQueryErrors(forError error : Graph.QueryError )  {
        
        switch(error) {
        case .request(let error):
            print("Non HTTPURL response was received. \(error.debugDescription)")
            
            if let nsError = error as NSError?{
                
                if (nsError.code == NSURLErrorTimedOut){
                    Alerter.shared.createAlert(withTitle: "Internet Error", andMessage: "The server took too long to respond or is offline.")
                }
                else if (nsError.code == NSURLErrorCannotConnectToHost || nsError.code == NSURLErrorNotConnectedToInternet ){
                    Alerter.shared.createAlert(withTitle: "Internet Error", andMessage: "No connection to internet")
                }
                else{
                    Alerter.shared.createAlert(withTitle: "OK", andMessage: "Something wrong went with your connection" )
                }
            }
            
            break
        case .http(let statusCode):
            print("HTTP error with code: \(statusCode)")
            Alerter.shared.createAlert(withTitle: "OK", andMessage: "Error with statusCode \(statusCode) " )
            break
        case .noData:
            print("The response contains no data")
            Alerter.shared.createAlert(withTitle: "OK", andMessage: " The response contains no data " )
            break
        case .jsonDeserializationFailed(let data):
            print("JSON deserialization failed, invalid syntax\\n")
            print("Data :\(String(describing: data))")
            Alerter.shared.createAlert(withTitle: "OK", andMessage: "JSON deserialization failed, invalid syntax")
            break
        case .invalidJson(let json):
            print("JSON structure doesn't match expression")
            print(json)
            Alerter.shared.createAlert(withTitle: "OK", andMessage: "JSON structure doesn't match expression")
            break
        case .invalidQuery(let reasons):
            print("The provided query was partially or completely invalid \\n")
            var errorMessage : String = ""
            for reason in reasons {
                print(reason.message,"\n")
                errorMessage = errorMessage + reason.message + "\n"
            }
            Alerter.shared.createAlert(withTitle: "OK", andMessage: errorMessage)
            break
        case .schemaViolation(let violation):
            print ("The response schema does not match expectation")
            print(violation.localizedDescription)
            Alerter.shared.createAlert(withTitle: "OK", andMessage: "The response schema does not match expectation")
            break
        }
    }
    
    func handleMutationErrors(forError errors : [Storefront.UserError] ) {
        
        var errorMessage : String = ""
        for userError in errors {
            print(userError.message)
            errorMessage = errorMessage + userError.message + "\n"
        }
        errorMessage = String(errorMessage.dropLast(1))
        print(errorMessage)
        Alerter.shared.createAlert(withTitle: "Error in Your Data", andMessage: errorMessage)
    }
}
