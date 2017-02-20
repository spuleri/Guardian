//
//  EventCell.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell, CellData {
    
    // Data
    var optionButtonHandler: ((Event) -> Void)?
    var event: Event?
    
    // Outlets
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    // MARK: CellData
    static var nibName: String {
        return "EventCell"
    }
    
    static var height: CGFloat {
        return 74.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(event: Event, tapClosure: ((Event)->())?) {

        // Set appropiate data
        self.event = event
        self.optionButtonHandler = tapClosure
        
        let date = event.timestamp
        let calendar = Calendar.current
        
        
        let month = Int(calendar.component(.month, from: date)).monthNumberToString()!
        let day = calendar.component(.day, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let calculatedEventTime = timeFormatter.string(from: date)
        let calculatedEventDate = ("\(month) \(day)")
        
        eventTitle.text = event.title
        eventDate.text = String(calculatedEventDate)
        eventTime.text = String(calculatedEventTime)
        
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        print("options button pressed")
        if let callback = self.optionButtonHandler,
            let theEvent = self.event {
            callback(theEvent)
        }
    }
}
