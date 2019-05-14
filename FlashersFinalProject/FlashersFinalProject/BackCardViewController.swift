//
//  BackCardViewController.swift
//  FlashersFinalProject
//
//  Created by Khalid Alkhatib on 4/26/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox.AudioServices

class BackCardViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var backText: UITextField!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    
    
    var frontTextData: String?
    var frontImageData: String?
    var backTextData: String?
    var backImageData: String?
    var cardID : Int64?
    var shouldSave : Bool?
    var object: NSManagedObject?
    var shouldSwipe : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        cameraButton.layer.cornerRadius = 10
        
        self.backText.delegate = self
        // Do any additional setup after loading the view.
        if backTextData != nil {
            backText.text = backTextData!
        }
        
        backText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        shouldSwipe = false
    }
    
    
    @IBAction func handleSwipe(recognizer:UISwipeGestureRecognizer) {
        
        if shouldSwipe! {
        performSegue(withIdentifier: "cardUnwind", sender: nil)
        }
        else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.view.shake()
        }
    }
    
    let cardSegueIdentifier = "cardUnwind"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FrontCardViewController, backTextData != nil
        {
            destination.backTextData = backTextData as! String
            destination.backImageData = backImageData
            destination.frontTextData = frontTextData
            destination.frontImageData = frontImageData
            destination.cardID = cardID as! Int64
            destination.shouldSave = shouldSave as! Bool
            destination.object = object
            destination.tutorialBool = false
        }
        else if segue.identifier == "collectionViewUnwind", let destination = segue.destination as? CardCollectionViewController {
            destination.cardTutorialBool = false
        }
    }
    
    @IBAction func backDeleteActionSheet(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Are you sure you wish to delete this card?", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            if self.object != nil {
                let delete = self.object
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                managedContext.delete(delete!)
                
                do {
                    try managedContext.save()
                } catch {
                    let nserror = error as NSError
                    NSLog("Unable to save \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
            
            self.performSegue(withIdentifier: "collectionViewUnwind", sender: nil)
        }
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func verifyIsDone(_ sender: Any) {
        if frontTextData != nil, backTextData != nil{
            if shouldSave == true {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Card", in: managedContext)
                
                if object == nil{
                    let card = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    card.setValue(cardID!, forKey: "deckID")
                    card.setValue(frontTextData!, forKey: "front")
                    card.setValue(backTextData!, forKey: "back")
                    if frontImageData != nil{
                        card.setValue(frontImageData!, forKey: "frontImage")
                    } else{
                        card.setValue("Logo_Transparent",forKey:"frontImage")
                    }
                    if backImageData != nil{
                        card.setValue(backImageData!, forKey: "backImage")
                    } else{
                        card.setValue("Logo_Transparent",forKey:"backImage")
                    }
                    
                    do {
                        try managedContext.save()
                    } catch {
                        let nserror = error as NSError
                        NSLog("Unable to save \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                    
                    cards.append(card)
                }
                else{
                    
                    object!.setValue(frontTextData!, forKey: "front")
                    object!.setValue(backTextData!, forKey: "back")
                    if frontImageData != nil{
                        object!.setValue(frontImageData!, forKey: "frontImage")
                    } else{
                        object!.setValue("Logo_Transparent",forKey:"frontImage")
                    }
                    if backImageData != nil{
                        object!.setValue(backImageData!, forKey: "backImage")
                    } else{
                        object!.setValue("Logo_Transparent",forKey:"backImage")
                    }
                        do {
                            try managedContext.save()
                        } catch {
                            let nserror = error as NSError
                            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
                            abort()
                        }
                }
            }
            // navigate from view or continue adding cards
            self.performSegue(withIdentifier: "collectionViewUnwind", sender: nil)
        }
            
        else{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.view.shake()
            let alert = UIAlertController(title: "Complete both sides of flashcard to save!",
                                          message: nil,
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss",
                                             style: .cancel)
            
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePickerController.sourceType = .camera
                self.present(imagePickerController,animated: true, completion: nil)
                
            }else{
                print("Camera not available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController,animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        backImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        backText.resignFirstResponder()
        shouldSwipe = true
        if backText.text != "", backText.text != backTextData  {
            backTextData = backText.text
            shouldSave = true
        }
        
        return true
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

