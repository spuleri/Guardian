//
//  CellData.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation
import UIKit

protocol CellData {
    static var nibName: String { get }
    
    static var identifier: String { get }
    
    static var estimatedHeight: CGFloat { get }
    
    static var height: CGFloat { get }
    
    static func registerWithTableView(tableView: UITableView)
    
}


// Default implementations
extension CellData {
    static func registerWithTableView(tableView: UITableView) {
        tableView.register(UINib.init(nibName: self.nibName, bundle: nil), forCellReuseIdentifier: self.identifier)
    }
    
    static var height: CGFloat {
        return 100
    }
    
    static var estimatedHeight: CGFloat {
        return UITableViewAutomaticDimension
    }
    
    static var identifier: String {
        return Self.nibName
    }
    
}
