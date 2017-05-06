//
//  SWMenuArrow.swift
//  SWMenuController
//
//  Created by Kaibo Lu on 2017/5/2.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class SWMenuArrow: UIImageView {

    var arrowDown: Bool = true
    
    var blankRect: CGRect = .zero
    var color: UIColor = UIColor(red: 0.161, green: 0.161, blue: 0.161, alpha: 1)
    
    func drawImage() {
        // To increase resolution, draw a large image
        let scaleFactor: CGFloat = 30
        let bounds = CGRect(x: 0,
                            y: 0,
                            width: self.bounds.width * scaleFactor,
                            height: self.bounds.height * scaleFactor)
        let blankRect = CGRect(x: self.blankRect.minX * scaleFactor,
                               y: self.blankRect.minY * scaleFactor,
                               width: self.blankRect.width * scaleFactor,
                               height: self.blankRect.height * scaleFactor)
        
        UIGraphicsBeginImageContext(bounds.size)
        color.setFill()
        
        let path = UIBezierPath()
        
        if arrowDown {
            // Arrow down
            path.move(to: .zero)
            let downCenter = CGPoint(x: bounds.width / 2, y: bounds.height)
            if blankRect.isEmpty {
                path.addLine(to: CGPoint(x: bounds.width, y: 0))
                path.addLine(to: downCenter)
                path.close()
                path.fill()
                
            } else {
                print(blankRect.width)
                // Left
                path.addLine(to: CGPoint(x: blankRect.minX, y: 0))
                
                if blankRect.minX < bounds.width / 2 {
                    let leftY = blankRect.minX / (bounds.width / 2) * bounds.height
                    path.addLine(to: CGPoint(x: blankRect.minX, y: leftY))
                    
                } else {
                    let leftY = (bounds.width - blankRect.minX) / (bounds.width / 2) * bounds.height
                    path.addLine(to: CGPoint(x: blankRect.minX, y: leftY))
                    path.addLine(to: downCenter)
                }
                path.close()
                path.fill()
                
                // Right
                let path2 = UIBezierPath()
                path2.move(to: CGPoint(x: bounds.width, y: 0))
                path2.addLine(to: CGPoint(x: blankRect.maxX, y: 0))
                
                if blankRect.maxX > bounds.width / 2 {
                    let rightY = (bounds.width - blankRect.maxX) / (bounds.width / 2) * bounds.height
                    path2.addLine(to: CGPoint(x: blankRect.maxX, y: rightY))
                    
                } else {
                    let rightY = blankRect.maxX / (bounds.width / 2) * bounds.height
                    path2.addLine(to: CGPoint(x: blankRect.maxX, y: rightY))
                    path2.addLine(to: downCenter)
                }
                path2.close()
                path2.fill()
            }
        } else {
            // Arrow up
            path.move(to: CGPoint(x: 0, y: bounds.height))
            let topCenter = CGPoint(x: bounds.width / 2, y: 0)
            if blankRect.isEmpty {
                path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                path.addLine(to: topCenter)
                path.close()
                path.fill()
                
            } else {
                print(blankRect.width)
                // Left
                path.addLine(to: CGPoint(x: blankRect.minX, y: bounds.height))
                
                if blankRect.minX < bounds.width / 2 {
                    let leftY = (1 - blankRect.minX / (bounds.width / 2)) * bounds.height
                    path.addLine(to: CGPoint(x: blankRect.minX, y: leftY))
                    
                } else {
                    let leftY = (1 - (bounds.width - blankRect.minX) / (bounds.width / 2)) * bounds.height
                    path.addLine(to: CGPoint(x: blankRect.minX, y: leftY))
                    path.addLine(to: topCenter)
                }
                path.close()
                path.fill()
                
                // Right
                let path2 = UIBezierPath()
                path2.move(to: CGPoint(x: bounds.width, y: bounds.height))
                path2.addLine(to: CGPoint(x: blankRect.maxX, y: bounds.height))
                
                if blankRect.maxX > bounds.width / 2 {
                    let rightY = (1 - (bounds.width - blankRect.maxX) / (bounds.width / 2)) * bounds.height
                    path2.addLine(to: CGPoint(x: blankRect.maxX, y: rightY))
                    
                } else {
                    let rightY = (1 - blankRect.maxX / (bounds.width / 2)) * bounds.height
                    path2.addLine(to: CGPoint(x: blankRect.maxX, y: rightY))
                    path2.addLine(to: topCenter)
                }
                path2.close()
                path2.fill()
            }
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
