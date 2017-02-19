//
//  SettingsViewController.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/19/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Nav
        styleNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleNavBar() {
        // Hide old navbar
        self.navigationController?.navigationBar.isHidden = true
        
        // Extra padding for top
        let extraPaddingBar = UIView.init(frame: CGRect(x: 0, y: 0.0, width: (self.parent?.view.frame.size.width)!, height: 15.0))
        extraPaddingBar.backgroundColor = UIColor.init(colorLiteralRed:0.26, green:0.29, blue:0.35, alpha:1.0)
        
        // Create new one with custom image
        let newNavBar = UINavigationBar.init(frame: CGRect(x: 0, y: 11.0, width: (self.parent?.view.frame.size.width)!, height: 64.0))
        newNavBar.setBackgroundImage(UIImage.init(named: "Settings Nav"), for: .default)
        newNavBar.tintColor = UIColor.white
        
        // Create BarButtonItem with out back icon
        let backItem = UINavigationItem()
        backItem.setHidesBackButton(true, animated: false)
        let backIcon = UIImage.init(named: "Back")
        let backButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(backButtonPressed))
        
        // Set the button as the left bar button itm
        backItem.setLeftBarButton(backButtonItem, animated: false)
        
        // Set items
        newNavBar.setItems([backItem], animated: false)
        
        // Add this custom Navbar as a subview
        self.view.addSubview(newNavBar)
        self.view.addSubview(extraPaddingBar)
    }
    
    func backButtonPressed(_ sender: Any) {
        print("Back button pressed")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func secretButtonPressed(_ sender: Any) {
        
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
