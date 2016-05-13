//
//  wordView.swift
//  WordGame
//
//  Created by 廖慶麟 on 2016/5/8.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

protocol wordGameDelegate: class{
    func giveMeNewModel(sender: wordView) -> Array<Array<String>>
}

class wordView: UIView {
    
    weak var delegate: wordGameDelegate?
    var wordModel: Array<Array<String>>!
    var widthPerUnit: CGFloat!
    var heightPerUnit: CGFloat!
    var wordLocations: Array<Array<CGPoint>>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        widthPerUnit = CGFloat(Float(self.frame.width-20)/8)
        heightPerUnit = CGFloat(Float(self.frame.height-35)/8)
        print(self.frame)
        
        // Int the location array of words
        wordLocations = Array<Array<CGPoint>>()
        for _ in 0...7{
            wordLocations.append(Array(count: 8, repeatedValue: CGPoint(x: 0.0, y: 0.0)))
        }
        
        var y = 30 + (heightPerUnit/4)
        for i in 0...7 {
            var x = 14 + (widthPerUnit/4)
            for j in 0...7 {
                wordLocations[i][j] = CGPoint(x: x, y: y)
                x += widthPerUnit
            }
            y += heightPerUnit
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.wordModel = (delegate?.giveMeNewModel(self))!
        
        // Draw vertical line
        var vStartPoint: CGPoint = CGPoint(x: 10.0, y: 25)
        var vEndPoint: CGPoint = CGPoint(x: 10.0, y: self.frame.height - 10)
        for _ in 0...8{
            var vPath = UIBezierPath()
            vPath.moveToPoint(vStartPoint)
            vPath.addLineToPoint(vEndPoint)
            vPath.closePath()
            UIColor.blueColor().set()
            vPath.stroke()
            
            // Update the CGPoint
            vStartPoint.x += widthPerUnit
            vEndPoint.x += widthPerUnit
        }
        
        // Draw horizontal line
        var hStartPoint: CGPoint = CGPoint(x: 10.0, y: 25)
        var hEndPoint: CGPoint = CGPoint(x: self.frame.width - 10, y: 25)
        for _ in 0...8{
            var hPath = UIBezierPath()
            hPath.moveToPoint(hStartPoint)
            hPath.addLineToPoint(hEndPoint)
            hPath.closePath()
            UIColor.blueColor().set()
            hPath.stroke()
            
            //Update the CGPoint
            hStartPoint.y += heightPerUnit
            hEndPoint.y += heightPerUnit
        }
        
        // Draw the new word
        
        // Set the word color
        let wordColor = UIColor.blackColor()
        // Set the font
        let wordFont = UIFont(name: "PingFangTC-Regular", size: 16)
        let wordFontAttributes: NSDictionary = [
            NSFontAttributeName: wordFont!,
            NSForegroundColorAttributeName: wordColor,
        ]
        for i in 0...7 {
            for j in 0...7 {
                var word = wordModel[i][j] as NSString
                word.drawAtPoint(wordLocations[i][j], withAttributes: wordFontAttributes as! [String : AnyObject])
            }
        }
        
        
    }

}
