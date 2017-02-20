//
//  ConcreteDashboardViewModel.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

protocol DashboardTableViewModel: TableViewModel {
    func removeEventByTitle(title: String) -> Bool
    var tapEventclosure: ((Event) -> ())? {get set}
}

class DashboardViewModel: DashboardTableViewModel {
    
    var events: [Event] = []
    
    var count: Int {
        return events.count
    }
    
    var tapEventclosure: ((Event) -> ())?
    
    
    func cellAtIndex(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        // Configure cell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Configure for this event
        cell.configure(event: events[indexPath.section], tapClosure: tapEventclosure)
        
        // Set the background image to white box with shadow image
        cell.backgroundView = UIImageView.init(image: UIImage.init(named: "Destination Background"))
        cell.selectedBackgroundView = UIImageView.init(image: UIImage.init(named: "Destination Background"))
        
        // Removes extra white background surrounding cell
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    func reloadData(tableView: UITableView) {
        // TODO: Network call to update events array
        
        let events = Event.decode()
        
        guard let theEvents = events else {
            // seed
            self.events = Event.seedEvents()
            tableView.reloadData()
            return
        }
        
        self.events = theEvents
        
        tableView.reloadData()
        
    }
    
    func removeEventByTitle(title: String) -> Bool {
        self.events = events.filter({$0.title == title})
//        Event.encode(events: self.events)
        return true
    }
    
    
}
