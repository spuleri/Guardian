//
//  Contact.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation


// http://stackoverflow.com/questions/32032380/saving-array-with-nscoding
// Super dope: http://nshipster.com/nscoding/
final class Contact: NSObject, NSCoding  {
    var name: String
    var phone: String
    var rank: Int
    var imageName: String
    var isEmergency: Bool
    
    // Member wise initializer
    init(name: String, phone: String, rank: Int, imageName: String, isEmergency: Bool) {
        self.name = name
        self.phone = phone
        self.rank = rank
        self.imageName = imageName
        self.isEmergency = isEmergency
    }
    
    // MARK: NSCoding
    public required convenience init?(coder aDecoder: NSCoder) {
        // Get Data
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let phone = aDecoder.decodeObject(forKey: "phone") as? String,
            let rank = aDecoder.decodeObject(forKey: "rank") as? Int,
            let imageName = aDecoder.decodeObject(forKey: "imageName") as? String,
            let isEmergency = aDecoder.decodeObject(forKey: "isEmergency") as? Bool
        else { return nil }
        
        // Create object with actual initializer
        self.init(name: name, phone: phone, rank: rank, imageName: imageName, isEmergency: isEmergency)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(isEmergency, forKey: "isEmergency")
    }
    
    static func path() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = documentsPath?.appending("/Contacts")
        return path!
    }
    
}
