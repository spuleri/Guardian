//
//  DashViewController.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

class DashViewController: UIViewController {
    
    @IBOutlet weak var checkinButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Guardian"
        
        if let user = GIDSignIn.sharedInstance().currentUser {
                print("Current google user is: \(user.profile.name)")
        }
        else {
            print("uh oh. no user currently signed in through google at the dash")
        }
        
        if let user = UserStore.instance.getCurrentUser() {
            print("Current local user is: \(user.name)")
        }
        else {
            print("uh oh. no user currently signed in locally at the dash")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkinButtonPressed(_ sender: Any) {
        NetworkManager.sharedInstance.sampleGet()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
