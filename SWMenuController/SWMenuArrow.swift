//
//  SWMenuArrow.swift
//  SWMenuController
//
//  Created by Kaibo Lu on 2017/5/2.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class SWMenuArrow: UIView {

    var arrowDown: Bool = true
    
    var blankRect: CGRect = .zero
    var color: UIColor = .darkGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 0
        color.setFill()

        if arrowDown {
            path.move(to: .zero)
            if blankRect.isEmpty {
                path.addLine(to: CGPoint(x: bounds.width, y: 0))
                path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
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
                    path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
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
                    path2.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
                }
                path2.close()
                path2.fill()
            }
        } else {
            path.move(to: CGPoint(x: bounds.width / 2, y: 0))
            if blankRect.isEmpty {
                path.addLine(to: CGPoint(x: 0, y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                path.close()
                path.fill()
                
            } else {
                
            }
        }
    }

}
