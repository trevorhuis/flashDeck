//
//  NewCardViewController.swift
//  FlashersFinalProject
//
//  Created by Ryan Cree on 4/26/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox.AudioServices



class FrontCardViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ModalViewControllerDelegate {
    
    @IBOutlet var frontText: UITextField!
    @IBOutlet var frontImage: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    
    
    
    var frontTextData: String?
    var frontImageData: String?
    var backTextData: String?
    var backImageData: String?
    var cardID : Int64?
    var shouldSave : Bool?
    var object : NSManagedObject?
    var shouldSwipe : Bool = false
    var tutorialBool: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        cameraButton.layer.cornerRadius = 10
        
        self.frontText.delegate = self
        // Do any additional setup after loading the view.
        if frontTextData != nil {
            frontText.text = frontTextData!
        }
        
        frontText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        print("\(tutorialBool)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (tutorialBool != nil) {
            if (tutorialBool!) {
                modalViewTutorial(segue: "tutorialFrontSegue")
                tutorialBool = false
            }
        }
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        shouldSwipe = false
    }
    
    @IBAction func cardUnwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func frontDeleteActionSheet(_ sender: Any) {
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
    
    @IBAction func verifyIfDone(_ sender: Any) {
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
        
        frontImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleSwipe(recognizer:UISwipeGestureRecognizer) {
        
        if shouldSwipe {
            
        self.performSegue(withIdentifier: "FrontCardSegue", sender: nil)
            
        }
        else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.view.shake()
        }
    }
    
    
    let frontSegueIdentifier = "FrontCardSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == frontSegueIdentifier,
            let destination = segue.destination as? BackCardViewController{
            if frontTextData != nil
        {
            destination.frontTextData = frontTextData as! String
            destination.frontImageData = frontImageData
            destination.backTextData = backTextData
            destination.backImageData = backImageData
        }
            destination.cardID = cardID as! Int64
            destination.shouldSave = shouldSave as! Bool
            destination.object = object
            destination.shouldSwipe = false
            if backTextData != nil {
                destination.shouldSwipe = true
            }
        }
        else if segue.identifier == "collectionViewUnwind", let destination = segue.destination as? CardCollectionViewController {
            destination.cardTutorialBool = false
        }
        else if segue.identifier == "tutorialFrontSegue" {
            if let viewController = segue.destination as? ModalViewController {
                viewController.delegate = self
                viewController.modalPresentationStyle = .overFullScreen
            }
        }
    }

    
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        frontText.resignFirstResponder()
        shouldSwipe = true
        if frontText.text != "", frontText.text != frontTextData  {
            frontTextData = frontText.text
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
     
     let delete = MyVariables.adventurers[indexPath.row]
     let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     managedContext.delete(delete)
     MyVariables.adventurers.remove(at: indexPath.row)
     tableView.deleteRows(at: [indexPath], with: .fade)
     do {
     try managedContext.save()
     } catch {
     let nserror = error as NSError
     NSLog("Unable to save \(nserror), \(nserror.userInfo)")
     abort()
     }
     }
     
     if you are a swift programmer this can help you :
     
     if you want to delete a NSManagedObject
     
     in my case ID is a unique attribute for entity STUDENT
     
     /** for deleting items */
     
     func Delete(identifier: String) {
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "STUDENT")
     let predicate = NSPredicate(format: "ID = '\(identifier)'")
     fetchRequest.predicate = predicate
     do
     {
     let object = try context.fetch(fetchRequest)
     if object.count == 1
     {
     let objectDelete = object.first as! NSManagedObject
     
     context.delete(objectDelete)
     }
     }
     catch
     {
     print(error)
     }
     }
     if you want to update a NSManagedObject :
     
     /** for updating items */
     func Update(identifier: String,name:String) {
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "STUDENT")
     let predicate = NSPredicate(format: "ID = '\(identifier)'")
     fetchRequest.predicate = predicate
     do
     {
     let object = try context.fetch(fetchRequest)
     if object.count == 1
     {
     let objectUpdate = object.first as! NSManagedObject
     objectUpdate.setValue(name, forKey: "name")
     do{
     try context.save()
     }
     catch
     {
     print(error)
     }
     }
     }
     catch
     {
     print(error)
     }
     }
     */
    
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
