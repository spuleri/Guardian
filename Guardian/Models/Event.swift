//
//  Event.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    var title: String
    let timestamp: Date


    // Memberwise initializer
    init(title: String, date: Date) {
        self.title = title
        self.timestamp = date
    }
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObject(forKey: "title") as? String,
            let timestamp = decoder.decodeObject(forKey: "timestamp") as? Date
            else { return nil }
        
        self.init(
            title: title,
            date: timestamp
        )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.timestamp, forKey: "timestamp")
        
    }
    
    // MARK: Persistence
    class func path() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = documentsPath?.appending("/Events")
        return path!
    }
    
    static func encode(events: [Event]) {
        NSKeyedArchiver.archiveRootObject(events, toFile: path())
    }
    
    static func decode() -> [Event]? {
        guard let events = NSKeyedUnarchiver.unarchiveObject(withFile: path()) as? [Event] else { return nil }
        return events
    }
}
