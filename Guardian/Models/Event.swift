//
//  Event.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation
import UserNotifications


class Event: NSObject, NSCoding {
    var title: String
    let timestamp: Date


    // Memberwise initializer
    init(title: String, date: Date) {
        self.title = title
        self.timestamp = date
    }
    
    static func seedEvents() -> [Event] {
        
        // Dummy data rn
        
        let now = Date()
        let cal = NSCalendar(calendarIdentifier: .gregorian)
        
        let next10Days = cal?.date(byAdding: NSCalendar.Unit.day, value: 10, to: now, options: [])
        let in30Minutes = cal?.date(byAdding: NSCalendar.Unit.minute, value: 30, to: now, options: [])
        let in2Hours = cal?.date(byAdding: NSCalendar.Unit.hour, value: 2, to: now, options: [])
        let in90Seconds = cal?.date(byAdding: NSCalendar.Unit.second, value: 90, to: now, options: [])
        let in45Seconds = cal?.date(byAdding: NSCalendar.Unit.second, value: 45, to: now, options: [])
        let in30Seconds = cal?.date(byAdding: NSCalendar.Unit.second, value: 30, to: now, options: [])
        
        
        let event1 = Event(title:"Demo", date: in30Minutes!)
        let event2 = Event(title:"Spring Break", date: next10Days!)
        let event3 = Event(title:"Gainesville", date: in2Hours!)
        let event4 = Event(title:"Here!", date: in90Seconds!)
        let event5 = Event(title:"Down the hall!", date: in45Seconds!)
        let event6 = Event(title:"Right here!", date: in30Seconds!)
        
        let events = [event1, event2, event3, event4, event5, event6]
        
        Event.encode(events: events)
        
        return events
        
    }
    
    static func deleteEvents() {
        do {
            try FileManager.default.removeItem(atPath: path())
            print("Removal of Events Successful!!!!")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
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
        

        
        for (index,event) in events.enumerated() {
            // Make notifiations of this
            let content = UNMutableNotificationContent()
            content.title = event.title
            content.body = "Verify that you're at this location"
            content.sound = UNNotificationSound.default()
            
            let timeInterval = event.timestamp.timeIntervalSinceNow
            print(timeInterval)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                            repeats: false)
            let identifier = "EventNote-\(index)"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                    print("unable to add to note center")
                }
            })
        }
   
    }
    
    static func decode() -> [Event]? {
        guard let events = NSKeyedUnarchiver.unarchiveObject(withFile: path()) as? [Event] else { return nil }
        return events
    }
}
