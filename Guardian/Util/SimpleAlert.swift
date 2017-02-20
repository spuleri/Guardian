//
//  SimpleAlert.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/20/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

extension UIViewController {
    func simpleAlert(title: String?, message: String, okAction: ((UIAlertAction) -> ())?,cancelAction: ((UIAlertAction) -> ())?, completion: (()->())? ) {
        let alertController = UIAlertController(title: "Check In", message: message, preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "Ok", style: .default, handler: okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: cancelAction)
        
        alertController.addAction(cancelAction)
        alertController.addAction(OkAction)
        
        self.present(alertController, animated: true, completion: completion)
    }
}
