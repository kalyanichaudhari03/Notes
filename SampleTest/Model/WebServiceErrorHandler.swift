//
//  WebServiceErrorHandler.swift
//  SampleTest
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class WebServiceErrorHandler {
    /**
     Description : Checking error in data, If error is nil then parse response and call successfulHandler handler, other wise it will call errorHandler with status code and error message
     
     - parameter object:            data recive from server
     - parameter error:             error object
     - parameter successfulHandler: successful handler
     - parameter errorHandler:      error handler
     */
 
    static func  checkForErrorInData(_ object:AnyObject, error:NSError?, successfulHandler:(_ responseDict:Dictionary<String, AnyObject>) -> Void, errorHandler:(_ errorDictionary:Dictionary<String, AnyObject>) -> Void){
        
        if  error != nil {
            errorHandler(["\(error!.code)":error!.localizedDescription as AnyObject])
        }
        else{
            do {
                if let jsonData = object as? Data {
                    let parsed = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments,
                                                                                                   .mutableContainers,
                                                                                                   .mutableLeaves])
                    if  JSONSerialization.isValidJSONObject(parsed) {
                        if parsed is NSArray {
                            successfulHandler(["result" : parsed as AnyObject])
                        }
                        else{
                            successfulHandler(parsed as! Dictionary)
                        }
                    }
                    else{
                        errorHandler(["Status": "-1" as AnyObject, "message":"Unknown error" as AnyObject])
                    }
                } else {
                    errorHandler(["Status": "-1" as AnyObject, "message":"Invalid JSON Data" as AnyObject])
                }
            }
            catch let errorInJson as NSError {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(errorInJson)")
                errorHandler(["Status": "\(errorInJson.code)" as AnyObject, "message":errorInJson.localizedDescription as AnyObject])
            }
        }
    }
}
