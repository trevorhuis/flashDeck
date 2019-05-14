//
//  PushButtonInvert.swift
//  FlashersFinalProject
//
//  Created by Ryan Cree on 5/5/19.
//  Copyright © 2019 Tyson Smiter & Ryan Cree. All rights reserved.
//

import UIKit

class PushButtonInvert: UIButton {
    override func draw(_ rect: CGRect) {
        
        let outlinePath = UIBezierPath(ovalIn: rect)
        
        UIColor(red: 59/255, green: 107/255, blue: 125/255, alpha: 1).setFill()
        outlinePath.fill()
        
        let path = UIBezierPath(ovalIn: rect)
        
        UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 0.9).setFill()
        path.fill()
        
        //set up the width and height variables
        //for the horizontal stroke
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        
        //Vertical Line
        
        plusPath.move(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight - halfPlusWidth + Constants.halfPointShift))
        
        plusPath.addLine(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        
        //set the stroke color
        UIColor(red: 59/255, green: 107/255, blue: 125/255, alpha: 1).setStroke()
        
        //draw the stroke
        plusPath.stroke()
    }
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
}
