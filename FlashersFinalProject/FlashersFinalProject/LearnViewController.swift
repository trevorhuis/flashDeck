//
//  LearnViewController.swift
//  FlashersFinalProject
//
//  Created by Luis Carlos Orozco on 4/26/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.


import UIKit
import CoreData

// Need to add the text to image function
// Need to add something that adjusts the text size
func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, fontSize: Float) -> UIImage {
    let textColor = UIColor.init(displayP3Red: 65.0/255.0, green: 179.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    let textFont = UIFont(name: "Helvetica Bold", size: CGFloat(fontSize))!
    
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
    
    let textFontAttributes = [
        NSAttributedString.Key.font: textFont,
        NSAttributedString.Key.foregroundColor: textColor,
        ] as [NSAttributedString.Key : Any]
    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    
    let rect = CGRect(origin: point, size: image.size)
    text.draw(in: rect, withAttributes: textFontAttributes)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

var cardList: [NSManagedObject]?
var maxCards: Int?



class LearnViewController: UIViewController, UITextFieldDelegate, ModalViewControllerDelegate {
    
    //var cards: [NSManagedObject] = []
    @IBOutlet weak var cardTextImage: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet var endSessionButton: UIButton!
    
    var isFlipped = false
    var usePicture = false
    var cardCount = 0
    var tutorialBool: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endSessionButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
        cardList = cardsShuffle(cards: cards)
        
        var cardImages = newCard()
        var frontImage = cardImages[0]
        var backImage = cardImages[1]
        
        var randomB = Bool.random()
        
        if self.randomB {
            self.cardTextImage.image = frontImage
            self.isFlipped = false
        } else {
            self.cardTextImage.image = backImage
            self.isFlipped = true
        }
        self.scoreAttempt.text = "Cards Left: " + String(cardList!.count) +  "     Correct: 0" 
        print("\(tutorialBool)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (tutorialBool != nil){
            if (tutorialBool!) {
                modalViewTutorial(segue: "tutorialLearnSegue")
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
    
    
    // RANDOMIZE LIST OF CARDS
    func cardsShuffle(cards: [NSManagedObject]) -> [NSManagedObject]{
        var learnCards : [NSManagedObject]
        learnCards = cards
        learnCards.shuffle()
        maxCards = learnCards.count
        cardCount = learnCards.count
        
        return learnCards
    }
    

    @IBAction func swipeLeft(_ sender: Any) {
        var cardImages = newCard()
        var frontImage = cardImages[0]
        var backImage = cardImages[1]
        
        if isFlipped {
            isFlipped = false
            cardTextImage.image = frontImage
            UIView.transition(with: cardTextImage, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            // This is if the card has a picture associated with it
            if usePicture {
                let image = UIImage(named: "logo_transparent")
                cardImageView.image = image
                UIView.transition(with: cardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            } else {
                // need to add code if they are using pictures
            }
            
        } else {
            isFlipped = true
            cardTextImage.image = backImage
            UIView.transition(with: cardTextImage, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            // This is if the card has a picture associated with it
            if usePicture {
                let image = UIImage(named: "logo_transparent")
                cardImageView.image = image
                UIView.transition(with: cardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            } else {
                // need to add code if they are using pictures
            }
        }
        
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        var cardImages = newCard()
        var frontImage = cardImages[0]
        var backImage = cardImages[1]
        
        
        if isFlipped {
            // This is used to track which side the card is on
            isFlipped = false
            // load in the images
            cardTextImage.image = frontImage
            UIView.transition(with: cardTextImage, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            // This is if the card has a picture associated with it
            if usePicture {
                let image = UIImage(named: "logo_transparent")
                cardImageView.image = image
                UIView.transition(with: cardImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            } else {
                // need to add code if they are using pictures
            }
            
            
        } else {
            isFlipped = true
            cardTextImage.image = backImage
            UIView.transition(with: cardTextImage, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            // This is if the card has a picture associated with it
            if usePicture {
                let image = UIImage(named: "logo_transparent")
                cardImageView.image = image
                UIView.transition(with: cardImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            } else {
                // need to add code if they are using pictures
            }
            
        }
    }
    
    @IBOutlet weak var scoreAttempt: UILabel!
    
    var score = 0.0
    var attempt = 0.0
    var pointer = 0
    var randomB = true
    var percentage = 0.0
    var correct = 0
    var percentScore = ""
    
    
    func forTrailingZero(temp: Double) -> String {
        var tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    @IBAction func yesButton(_ sender: Any) {
        score = score + 1
        attempt = attempt + 1
        pointer += 1
        percentage = round((score/attempt) * 100)
        correct = Int(score)
        cardCount -= 1


        percentScore = forTrailingZero(temp: percentage) + "%"
        self.scoreAttempt.text = "Cards Left: " + String(cardCount) +  "     Correct: " + String(correct)
        
        if pointer == maxCards! {
            newFunction()
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.cardImageView.frame.origin.y -= 1000
                self.cardTextImage.frame.origin.y -= 1000
            }, completion: { (finished: Bool) in
                self.cardImageView.alpha = 0
                self.cardTextImage.alpha = 0
                
                var cardImages = self.newCard()
                var frontImage = cardImages[0]
                var backImage = cardImages[1]
                
                var randomB = Bool.random()
                
                if self.randomB {
                    self.cardTextImage.image = frontImage
                    self.isFlipped = false
                } else {
                    self.cardTextImage.image = backImage
                    self.isFlipped = true
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.cardImageView.frame.origin.y += 1000
                    self.cardTextImage.frame.origin.y += 1000
                    
                }, completion: { (finished: Bool) in
                    UIView.animate(withDuration: 0.7, animations: {
                        self.cardImageView.alpha = 1.0
                        self.cardTextImage.alpha = 1.0
                    }, completion: nil)
                })
            })
        }
        isFlipped = false
    }

    @IBAction func noButton(_ sender: Any) {
        cardList!.append(cardList![pointer])
        attempt = attempt + 1
        pointer += 1
        maxCards! += 1
        self.scoreAttempt.text = "Cards Left: " + String(cardCount) +  "     Correct: " + String(correct)
        isFlipped = false
        percentage = round((score/attempt) * 100)
        percentScore = forTrailingZero(temp: percentage) + "%"

        UIView.animate(withDuration: 0.3, animations: {
            self.cardImageView.frame.origin.y += 1000
            self.cardTextImage.frame.origin.y += 1000
        }, completion: { (finished: Bool) in
            self.cardImageView.alpha = 0
            self.cardTextImage.alpha = 0
            
            var cardImages = self.newCard()
            var frontImage = cardImages[0]
            var backImage = cardImages[1]
            
            var randomB = Bool.random()
            
            if self.randomB {
                self.cardTextImage.image = frontImage
                self.isFlipped = false
            } else {
                self.cardTextImage.image = backImage
                self.isFlipped = true
            }
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.cardImageView.frame.origin.y -= 1000
                self.cardTextImage.frame.origin.y -= 1000
                
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.7, animations: {
                    self.cardImageView.alpha = 1.0
                    self.cardTextImage.alpha = 1.0
                }, completion: nil)
            })
        })
        isFlipped = false

    }
    
    
    func newCard() -> Array<UIImage> {
        var card = cardList![pointer]
        var frontText = card.value(forKey: "front") as! String
        var backText = card.value(forKey: "back") as! String
        
        var frontFont:Float = 80.0
        var backFont:Float = 80.0
        
        if frontText.count > 50 {
            frontFont = 40.0
        }
        
        if backText.count > 50 {
            backFont = 40.0
        }
        
        let borderColor = UIColor.init(displayP3Red: 65.0/255.0, green: 179.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let imgOriginal = UIImage.init(named: "white.jpg")
        var imageBase = imgOriginal?.imageWithBorder(width: 4, color: borderColor)
        
        var frontImage = textToImage(drawText: frontText, inImage: imageBase!, atPoint:CGPoint(x: 20, y: 20), fontSize: frontFont)
        
        var backImage = textToImage(drawText: backText, inImage: imageBase!, atPoint:CGPoint(x: 20, y: 20), fontSize: backFont)
        
        
        
        // Need to add the images taken by the user
        
        var cardImages = [frontImage, backImage]
        
        return cardImages
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "collectionViewUnwind", let destination = segue.destination as? CardCollectionViewController {
            destination.learnTutorialBool = false
        }
        else if segue.identifier == "tutorialLearnSegue" {
            if let viewController = segue.destination as? ModalViewController {
                viewController.delegate = self
                viewController.modalPresentationStyle = .overFullScreen
            }
        }
        
    }

    
    // MARK: NAVIGATION
    @IBAction func endSession(_ sender: Any) {
        let alert = UIAlertController(title: "Exit Learning Session", message: "Are you sure you wish to exit this session?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(ACTION) in alert.dismiss(animated: true)
        
            
        }))
       
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(ACTION) -> Void in alert.dismiss(animated: true)
            
            self.performSegue(withIdentifier: "collectionViewUnwind", sender: nil)
            
        }))
        
        self.present(alert, animated: true)
    }
    
    func newFunction() {
        let alert = UIAlertController(title: "All Done!", message: "Would you like to share your score of " + percentScore + " on Social Media?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No thanks", style: .default, handler: {(ACTION) -> Void in alert.dismiss(animated: true)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            self.performSegue(withIdentifier: "collectionViewUnwind", sender: nil)
        
        }))
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: {(ACTION) in alert.dismiss(animated: true)
            let prompt = "I got a score of " + self.percentScore + " on my flashcards using the FlashDeck App!"
            let activityController = UIActivityViewController(activityItems: [prompt], applicationActivities: nil)
            
            activityController.completionWithItemsHandler = { (nil, completed, _, error)
                in
                self.performSegue(withIdentifier: "collectionViewUnwind", sender: nil)
            }
            self.present(activityController, animated: true)
            
        }))
        
        self.present(alert, animated: true)
        
        }
    }

extension UIImage {
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 5, height: min(size.width, size.height) + width * 5)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
