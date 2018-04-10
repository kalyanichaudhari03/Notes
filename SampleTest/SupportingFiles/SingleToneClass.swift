//
//  SingleToneClass.swift
//  SampleTest
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SingleToneClass: NSObject {
        static let shared = SingleToneClass()
        var arrNotes:[EntityNote] = []
}
