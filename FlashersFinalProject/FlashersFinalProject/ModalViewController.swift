//
//  ModalViewController.swift
//  FlashersFinalProject
//
//  Created by Luis Carlos Orozco on 5/9/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate: class {
    func removeBlurredBackgroundView()
}

class ModalViewController: UIViewController {
    
    weak var delegate: ModalViewControllerDelegate?
    
    @IBAction func tap(recognizer:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    override func viewDidLayoutSubviews() {
        view.backgroundColor = UIColor.clear
        
    }
    
    
}
