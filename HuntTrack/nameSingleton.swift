//
//  nameSingleton.swift
//  HuntTrack
//
//  Created by Evan Weisbrod on 5/1/16.
//  Copyright © 2016 Evan Weisbrod. All rights reserved.
//

import Foundation
import Firebase

class nameSingleton: NSObject
{
    static var currUsername : String?
    static var partymembers = [String]()
    static var memberlats = [String]()
    static var memberlongs = [String]()
    static var memberslist = [String]()
    static var addedmember : String? 
    static var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
}