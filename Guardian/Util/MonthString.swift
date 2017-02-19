//
//  MonthString.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/19/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

extension Int {
    func monthNumberToString() -> String? {
        if self < 1 || self > 12 {
            print("u cant use this!!, must be an int between 1 and 12")
            return nil
        } else {
            switch self {
            case 1:
                return "Jan"
            case 2:
                return "Feb"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "June"
            case 7:
                return "July"
            case 8:
                return "Aug"
            case 9:
                return "Sept"
            case 10:
                return "Oct"
            case 11:
                return "Nov"
            case 12:
                return "Dec"
            default:
                break
                return nil
            }
        }
        
        return nil
    }
}
