//
//  ConcreteDashboardViewModel.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation


class DashboardViewModel: TableViewModel {
    
    var events: [Event] = []
    
    var count: Int {
        return events.count
    }
    
    
    func cellAtIndex(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        // Configure cell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Configure for this event
        cell.configure(event: events[indexPath.section])
        
        // Set the background image to white box with shadow image
        cell.backgroundView = UIImageView.init(image: UIImage.init(named: "Destination Background"))
        cell.selectedBackgroundView = UIImageView.init(image: UIImage.init(named: "Destination Background"))
        
        // Removes extra white background surrounding cell
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    func seedEvents() {
        // Dummy data rn
        
        let now = Date()
        let cal = NSCalendar(calendarIdentifier: .gregorian)
        
        let next10Days = cal?.date(byAdding: NSCalendar.Unit.day, value: 10, to: now, options: [])
        let in30Minutes = cal?.date(byAdding: NSCalendar.Unit.minute, value: 30, to: now, options: [])
        let in2Hours = cal?.date(byAdding: NSCalendar.Unit.hour, value: 2, to: now, options: [])
        let in30Seconds = cal?.date(byAdding: NSCalendar.Unit.second, value: 30, to: now, options: [])
        
        
        let event1 = Event(title:"Demo", date: in30Minutes!)
        let event2 = Event(title:"Spring Break", date: next10Days!)
        let event3 = Event(title:"Gainesvilles", date: in2Hours!)
        let event4 = Event(title:"Here!", date: in30Seconds!)
        
        events = [event1, event2, event3, event4]
        
        Event.encode(events: events)
    }
    func reloadData(tableView: UITableView) {
        // TODO: Network call to update events array
        
        let events = Event.decode()
        
        guard let theEvents = events else {
            // seed
            seedEvents()
            tableView.reloadData()
            return
        }
        
        self.events = theEvents
        
        tableView.reloadData()
        
    }
    
    
}
