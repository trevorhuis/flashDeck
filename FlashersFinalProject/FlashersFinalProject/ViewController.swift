//
//  ViewController.swift
//  FlashersFinalProject
//
//  Created by Ryan Cree on 4/15/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//
import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var button: PushButton?
    // Connect the table view
    @IBOutlet weak var tableView: UITableView!
    
    // manage objects from Core Data
    var decks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        button = PushButton(frame:CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 60, y: self.view.frame.size.height - 175), size: CGSize(width: 120, height: 120)))
        
        button!.addTarget(self, action: #selector(addDeck(_:)), for: .touchUpInside)
        self.navigationController?.view.addSubview(button!)
        
    }
    
    // Fetch from core data
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Deck")
        
        //3
        do {
            decks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if decks.count == 0 {
            addPlist()
        }
    }
    
    
    // Add a new deck
    @IBAction func addDeck(_ sender: Any) {
        let alert = UIAlertController(title: "New Deck Name",
                                      message: "Add a new deck",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button!.isHidden = true
    }
    
    // save new deck to core data
    func save(name: String) {
        
        let randomID = Int64.random(in: 2 ... 100000) * Int64.random(in: 2 ... 877)
        print("\(randomID)")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Deck",
                                       in: managedContext)!
        
        let deck = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        deck.setValue(name, forKeyPath: "name")
        deck.setValue(randomID,forKeyPath:"id")
        deck.setValue(true, forKeyPath: "firstTime")
        
        // 4
        do {
            try managedContext.save()
            decks.append(deck)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // populate Table View
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate

            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        if editingStyle == .delete
        {
            do
            {
                managedContext.delete(decks[indexPath.row])
                
                decks.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                try managedContext.save()
    
                tableView.reloadData()
            }
            catch
            {
                let nserror = error as NSError
                
                NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
                
                abort()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "deckCell",
                                          for: indexPath) as! deckCell
        let deckName = decks[indexPath.row]
        cell.deckName.text = deckName.value(forKeyPath: "name") as? String
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    @IBAction func tableViewUnwindSegue(_ sender: UIStoryboardSegue) {
        button!.isHidden = false
        self.tableView.reloadData()
    }
    
    
    func addPlist() {
        
        var cardFront: String = ""
        var cardBack: String = ""
        
        let randomID = Int64.random(in: 2 ... 100000) * Int64.random(in: 2 ... 877)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // load in data from custom animal plist
        let inputFile = Bundle.main.path(forResource: "Decks", ofType: "plist")
        let inputArray = NSArray(contentsOfFile: inputFile!)
        
        // loop through the array/dictionary
        for item in inputArray as! [NSDictionary] {
            // load in the description accordingly
            for entry in item {
                let key:String! = (entry.key) as? String
                let value:String! = item[key] as? String
                
                switch(key)
                {
                case "front":
                    cardFront = value
                    break
                case "back":
                    cardBack = value
                    break
                default:
                    break
                }
                
            }
            
            // 2
            let entity =
                NSEntityDescription.entity(forEntityName: "Card", in: managedContext)!
            
            let card = NSManagedObject(entity: entity, insertInto: managedContext)
            
            card.setValue(cardFront, forKey: "front")
            card.setValue(cardBack, forKey: "back")
            card.setValue(randomID, forKey: "deckID")
            card.setValue("Logo_Transparent", forKey: "frontImage")
            card.setValue("Logo_Transparent", forKey: "backImage")
        }

        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Deck",
                                       in: managedContext)!
        
        let deck = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        deck.setValue("Presidents", forKeyPath: "name")
        deck.setValue(randomID ,forKeyPath:"id")
        deck.setValue(true, forKeyPath: "firstTime")
        
        // 4
        do {
            try managedContext.save()
            decks.append(deck)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Navigation
    let cardSegueIdentifier = "ShowCardSegue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cardSegueIdentifier,
            let destination = segue.destination as? CardCollectionViewController,
            let chosenRow = tableView.indexPathForSelectedRow?.row
        {
            
            destination.cardID = decks[chosenRow].value(forKey: "id") as! Int64
            destination.deckName = decks[chosenRow].value(forKey: "name") as! String
            destination.deckObject = decks[chosenRow] as! NSManagedObject
            if decks[chosenRow].value(forKey:"firstTime") as! Bool{
                destination.tutorialBool = true
                destination.cardTutorialBool = true
                destination.learnTutorialBool = true
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Deck", in: managedContext)
                
                decks[chosenRow].setValue(false, forKey: "firstTime")
                
                do {
                    try managedContext.save()
                } catch {
                    let nserror = error as NSError
                    NSLog("Unable to save \(nserror), \(nserror.userInfo)")
                    abort()
                }
                
            }
        }
    }

}
