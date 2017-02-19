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
    
    func reloadData(tableView: UITableView) {
        // TODO: Network call to update events array
        
        // Dummy data rn
        
        let event1 = Event(title:"Marriott", timestamp: Date(), location: "here")
        
        events = [event1, event1, event1]
        
        tableView.reloadData()
        
    }
    
    
}
