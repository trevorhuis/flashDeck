//
//  CardCollectionViewController.swift
//  FlashersFinalProject
//
//  Created by Ryan Cree on 4/22/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//
import UIKit
import CoreData
import AudioToolbox.AudioServices

var cards: [NSManagedObject] = []

class CardCollectionViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ModalViewControllerDelegate {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet var reminders: UIButton!
    @IBOutlet var learn: UIButton!
    
    var cardID : Int64?
    var deckName: String?
    var button: PushButtonInvert?
    var deckObject: NSManagedObject?
    
    // set tutorial Bool to false after it is used
    var tutorialBool: Bool?
    
    // return from card view will set card tutorial bool to false
    var cardTutorialBool: Bool?
    
    // return from learn view will set bool to falce
    var learnTutorialBool: Bool?
    
    @IBOutlet weak var deckTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        deckTitle.text = deckName!
        reminders.layer.cornerRadius = 10
        learn.layer.cornerRadius = 10
        button = PushButtonInvert(frame:CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 50, y: self.view.frame.size.height - 195), size: CGSize(width: 100, height: 100)))
        
        button!.addTarget(self,action: #selector(addSegue(_:)), for: .touchUpInside)
        self.view.addSubview(button!)
        print("\(tutorialBool)")
        print("\(cardTutorialBool)")
        print("\(learnTutorialBool)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       if (tutorialBool != nil) {
            if (tutorialBool!) {
                modalViewTutorial(segue: "tutorialSegue")
                tutorialBool = false
            }
        }
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Card")
        fetchRequest.predicate = NSPredicate(format:"deckID = %@", "\(cardID!)")
        //3
        do {
            cards = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func overlayBlurredBackgroundView() {
        
        let blurredBackgroundView = UIVisualEffectView()
        
        blurredBackgroundView.frame = view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .dark)
        blurredBackgroundView.alpha = 0.55
        
        view.addSubview(blurredBackgroundView)
        
    }
    
    func removeBlurredBackgroundView() {
        
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func modalViewTutorial(segue: String) {
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.overlayBlurredBackgroundView()
        self.performSegue(withIdentifier: segue, sender: nil)
    }
    
    //MARK: UICollectionViewDataSource
    @IBAction func collectionViewUnwindSegue(_ sender: UIStoryboardSegue) {
       self.cardCollectionView.reloadData()
        print("\(cardTutorialBool)")
        print("\(learnTutorialBool)")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardIdentifier", for: indexPath as IndexPath) as! CardCollectionViewCell
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 10
        let cardName = cards[indexPath.row]
        let cardText = cardName.value(forKey: "front") as! String
        if cardText.count > 10 {
            let indexStartOfText = cardText.index(cardText.startIndex, offsetBy: 10)
            let substring = String(cardText[...indexStartOfText])
            cell.cardLabel.text = substring
        }
        else {
            cell.cardLabel.text = cardText
        }
        return cell
    }
   
    @IBAction func tapNameChange(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Deck Name",
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.editName(name: nameToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    
    }
    
    
    func editName (name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: managedContext)
     
        deckObject!.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            deckTitle.text = name
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }
    
    
    //MARK: Navigation
    let editSegueIdentifier = "cellSelectEdit"
    let addSegueIdentifier = "CardAddSegue"
    let calendarSegueIdentifier = "calendarAdd"
    
    @IBAction func addSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "CardAddSegue", sender: nil)
    }
    
    @IBAction func learnSegue(_ sender: Any) {
        if cards.count != 0 {
            self.performSegue(withIdentifier: "learnSegue", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "Add cards to access learning sessions!",
                                          message: nil,
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss",
                                             style: .cancel)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.view.shake()
        }
}
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addSegueIdentifier,
            let destination = segue.destination as? FrontCardViewController
        {
            destination.cardID = cardID as! Int64
            destination.shouldSave = true
            if cardTutorialBool != nil{
                if cardTutorialBool! {
                    destination.tutorialBool = true
                }
                
            }
        }
            
        else if segue.identifier == calendarSegueIdentifier, let destination = segue.destination as? CalendarViewController {
            destination.deckName = deckName!
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
            
        else if segue.identifier == editSegueIdentifier,
            let destination = segue.destination as? FrontCardViewController,
            let indexPath = self.cardCollectionView.indexPathsForSelectedItems?.first{
            let card = cards[indexPath[1]]
            destination.object = card
            destination.frontImageData = card.value(forKey: "frontImage") as! String
            destination.frontTextData = card.value(forKey:"front") as! String
            destination.backTextData = card.value(forKey:"back") as! String
            destination.backImageData = card.value(forKey: "backImage") as! String
            destination.cardID = card.value(forKey: "deckID") as! Int64
            destination.shouldSave = false
            destination.shouldSwipe = true
            
            if cardTutorialBool != nil{
                if cardTutorialBool! {
                    destination.tutorialBool = true
                }
            }
        }
        else if segue.identifier == "learnSegue"{
            if learnTutorialBool != nil{
                if learnTutorialBool! {
                    let destination = segue.destination as! LearnViewController
                    destination.tutorialBool = true
                }
                
            }
        }
        else if segue.identifier == "tutorialSegue" {
            if let viewController = segue.destination as? ModalViewController {
                viewController.delegate = self
                viewController.modalPresentationStyle = .overFullScreen
            }
        }
    }

    
    //MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 166, height: 166)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
