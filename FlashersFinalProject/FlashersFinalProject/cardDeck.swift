////
////  cardDeck.swift
////  FlashersFinalProject
////
////  Created by Trevor on 4/22/19.
////  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
////
//
//import UIKit
//import Foundation
/// hello
////class Card {
////    var front: String?
////    var back: String?
////
////    init(front: String?, back: String?){
////        self.front = front
////        self.back = back
////
////    }
////
////}
//
//
//// create a class animals to hold the image and description
//class Deck {
//
//    var name: String?
//    static var selectedIndex = 0
////    var cards: NSMutableArray?
//
//
//
//    init(name: String, cards:NSMutableArray){
//        self.name = name
////        self.cards = cards
//
//    }
//
//    init(){
//    }
//
////    func addCard(front:String?, back:String?) {
////        let newCard = Card(front: front, back: back)
////        cards!.add(newCard)
////    }
//
//
//    // load animal class into array
//    static func loadDecks() -> [Deck]
//    {
//        var decks = [Deck]()
//
//        // load in data from custom animal plist
//        let inputFile = Bundle.main.path(forResource: "Decks", ofType: "plist")
//        let inputArray = NSArray(contentsOfFile: inputFile!)
//
//        // loop through the array/dictionary
//        for item in inputArray as! [NSDictionary]
//        {
//            let deck:Deck = Deck()
//
//            // load in the description accordingly
//            for entry in item
//            {
//                let key:String! = (entry.key) as? String
//                let value:String! = item[key] as? String
//
//                switch(key)
//                {
//                case "name":
//                    deck.name = value
//                    break
//                default:
//                    break
//                }
//            }
//            decks.append(deck)
//        }
//        return decks
//    }
//}
//
