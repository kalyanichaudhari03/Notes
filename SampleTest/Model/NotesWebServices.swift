//
//  NotesWebServices.swift
//  SampleTest
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class NotesWebServices: NSObject {
    var callbackerror:((_ errorMsg:String) -> Void)?
    var callbackSuccessNotes :((_ arrResponse : [EntityNote]) -> Void)?
    var callbackSuccess : ((_ response : [String:AnyObject])-> Void)?
    
    func requestToGetNotesList(_ successfulHandler:@escaping (_ responseDict:[EntityNote]) -> Void, errorHandler:@escaping (_ ErrMessage:String) -> Void){
        self.callbackSuccessNotes = successfulHandler
        self.callbackerror = errorHandler
        
        let strURl = "Webservice URL"
        Alamofire.request(strURl).responseJSON { response in
            if response.data != nil{
                if response.data != nil{
                    WebServiceErrorHandler.checkForErrorInData(response.data! as AnyObject, error: nil, successfulHandler: { (responseDict) -> Void in
                        if let JSON = response.result.value {
                            //store user data
                            print("JSON: \(JSON)")
                            let array = EntityNote().returnArrayNotesFromResponse(reponse:responseDict )
                            self.callbackSuccessNotes!(array)
                            
                        }
                    }, errorHandler: { (errorDictionary) -> Void in
                        //Show message
                        self.callbackerror!("Error while fetching data")
                    })
                }
                else{
                    //Show message
                    self.callbackerror!("Error while fetching data")
                }
            }
        }
            //Testing with sample Data
            //As We don't have any backend with us returning EmptyData
            var tempSampleArray = [ EntityNote.init(iId: 1, strNotes: "Testing Notes") ,
                                    EntityNote.init(iId: 2, strNotes: "Sample Notes") ,
                                    EntityNote.init(iId: 3, strNotes: "Monday Notes") ,
                                    EntityNote.init(iId: 4, strNotes: "Tuesday Notes")]
            self.callbackSuccessNotes!(tempSampleArray)
        
        
        
    }
    
    func requestToSaveNote(_ iId:Int,  sNote:String, successfulHandler:@escaping (_ responseDict:[String:AnyObject]) -> Void, errorHandler:@escaping (_ ErrMessage:String) -> Void){
        self.callbackSuccess = successfulHandler
        self.callbackerror = errorHandler
        
        let strURl = "Webservice URL"+"id=\(iId)&Notes=\(sNote)"
        Alamofire.request(strURl).responseJSON { response in
            if response.data != nil{
                if response.data != nil{
                    WebServiceErrorHandler.checkForErrorInData(response.data! as AnyObject, error: nil, successfulHandler: { (responseDict) -> Void in
                        if let JSON = response.result.value {
                            //store user data
                            print("JSON: \(JSON)")
                            self.callbackSuccess!(responseDict)
                        }
                    }, errorHandler: { (errorDictionary) -> Void in
                        //Show message
                        self.callbackerror!("Error while fetching data")
                    })
                }
                else{
                    //Show message
                    self.callbackerror!("Error while fetching data")
                }
            }
        }
    }
}
