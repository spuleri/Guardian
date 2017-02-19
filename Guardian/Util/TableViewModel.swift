//
//  TableViewModel.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

protocol TableViewModel {
    
    var count: Int { get }
    
    func cellAtIndex(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func reloadData(tableView: UITableView)
}
