//
//  EntityNote.swift
//  SampleTest
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class EntityNote: NSObject,NSCoding {
    var iId: Int?
    var strNotes: String?
    
    override init() {
        
        super.init()
    }
    
    init(iId: Int, strNotes: String) {
        
        self.iId = iId
        self.strNotes = strNotes
    }
    
    required init(coder decoder: NSCoder) {
        
        self.iId = decoder.decodeInteger(forKey:"id")
        self.strNotes = decoder.decodeObject(forKey: "strNotes") as? String ?? ""
        
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(self.iId, forKey: "iId")
        coder.encode(self.strNotes, forKey: "strNotes")
        
    }
    
    func returnArrayNotesFromResponse(reponse:[String : AnyObject])-> [EntityNote]{
        var arrNotesList = [EntityNote]()
            for jsonItem in reponse {
                if let noteDict = jsonItem as? [String : AnyObject] {
                    if let note =   EntityNote.noteFromJSONData(jsonData:noteDict) {
                        arrNotesList.append(note)
                    }
                }
            }
        return arrNotesList
    }
    
   
    /*
     */
    static func noteFromJSONData(jsonData: [String : AnyObject]) -> EntityNote? {
        var iId: Int = 0
        var sNote : String = ""
      
        
        if let tempid = jsonData["id"] as? Int {
            iId = tempid
        }
        if let tempnote = jsonData["note"] as? String {
            sNote = tempnote
        }
      
        let note = EntityNote.init(iId:iId , strNotes: sNote)
        return note
    }
}
