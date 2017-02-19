//
//  ContactsViewModel.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

protocol ContactsTableViewModel: TableViewModel {
    func exchangeObjectAtIndex(index: Int, withObjectAtIndex otherIndex: Int)
}

class ContactsViewModel: ContactsTableViewModel {
    
    var contacts: [Contact] = []
    
    var dragDelegate: DragCellDelegate
    
    init(dragDelegate: DragCellDelegate) {
        self.dragDelegate = dragDelegate
    }
    
    var count: Int {
        return contacts.count
    }    
    
    func cellAtIndex(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        // Configure cell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Configure for this event
        let contact = contacts[indexPath.section]
    
        // Configure cell
        cell.configure(contact: contact)
        
        cell.delegate = self.dragDelegate
        
        // Removes extra white background surrounding cell
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func reloadData(tableView: UITableView) {
        // TODO: Network call to update events array
    
        // Dummy data rn
//        
//        let contact1 =  Contact(name: "Joseph Pena", phone: "410.982.3341", rank: 1, imageName: "Joseph", isEmergency: false)
//        
//        let contact2 =  Contact(name: "Sergio Puleri", phone: "407/332.9164", rank: 2, imageName: "Sergio", isEmergency: false)
//        
//        let contact3 =  Contact(name: "Tatiana Rincon", phone: "889.945.3620", rank: 3, imageName: "Tatiana", isEmergency: false)
//        
//        let contact4 =  Contact(name: "Conor Landry", phone: "342.880.3912", rank: 4, imageName: "Conor", isEmergency: false)
        
        // Add on extra emergency contact always
        let emergencyContact =  Contact(name: "", phone: "", rank: 5, imageName: "", isEmergency: true)
//        contacts = [contact1, contact2, contact3, contact4]
        
        contacts = (UserStore.instance.getCurrentUser()?.contacts)!
        
        contacts.append(emergencyContact)
        
        // Always sort by rank
        contacts.sort(by: { $0.rank < $1.rank})
        
        tableView.reloadData()
        
    }
    
    func exchangeObjectAtIndex(index: Int, withObjectAtIndex otherIndex: Int) {
        // TODO: must persist the change to DB too since we are updating rank
        var contact1 = contacts[index]
        
        var contact2 = contacts[otherIndex]
        
        let rank1 = contact1.rank
        
        let rank2 = contact2.rank
        
        // Swap ranks
        contact1.rank = rank2
        contact2.rank = rank1
        
        
        // Always sort by rank
        contacts.sort(by: { $0.rank < $1.rank})
    }
    
    
}
