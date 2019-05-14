//
//  CalendarViewController.swift
//  FlashersFinalProject
//
//  Created by Trevor on 4/26/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class CalendarViewController: UIViewController, UITextFieldDelegate {
    
    var deckName: String?
    
    // 1
    let eventStore = EKEventStore()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var addReminderButton: UIButton!
    
    
    @IBAction func setReminder(_ sender: Any) {
        let alert = UIAlertController(title: "Reminder Set", message: "Now get back to studying!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: self!.eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReminderButton.layer.cornerRadius = 10
    }
    
    func insertEvent(store: EKEventStore) {
        // 1
        
        let calendars = store.calendars(for: .event)
        
        
        for calendar in calendars {
            // 2
            if calendar.title == "Calendar" {
                // 3
                let startDate = datePicker.date
                
                // 2 hours
                let endDate = startDate.addingTimeInterval(1 * 30 * 60)
                
                // 4
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = ("\(deckName!) study session")
                event.startDate = startDate
                event.endDate = endDate
                
                
                // 6
                do {
                    try store.save(event, span: .thisEvent)
                }
                catch {
                    print("Error saving event in calendar")
                }
            }
        }
    }
    
    /*func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
     studyTitle.resignFirstResponder()
     return true
     }*/
    
}
