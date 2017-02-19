//
//  DataViewController.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/19/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func seedEventsButtonPressed(_ sender: Any) {
        Event.seedEvents()
    }

    @IBAction func deleteEventsButtonPressed(_ sender: Any) {
        Event.deleteEvents()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
