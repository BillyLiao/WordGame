//
//  ViewController.swift
//  WordGame
//
//  Created by 廖慶麟 on 2016/5/8.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class ViewController: UIViewController, wordGameDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    var gameView: wordView!
    var wordArray = Array<Array<String>>()
    var textField: UITextField!
    var scrollView: UIScrollView!
    var tapGes: UITapGestureRecognizer!
    var row: Int?
    var column: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the word model
        var wArray = ["林","鶯","真","是","太","美","了","啊"]
        for _ in 0...7 {
            wordArray.append(wArray)
        }
        
        // Init textField
        textField = UITextField.init(frame: CGRect(x: 0, y: 0, width: CGFloat((self.view.frame.width-20)/8), height: CGFloat((self.view.frame.height-35)/8)))
        textField.textColor = UIColor.whiteColor()
        textField.backgroundColor = UIColor.blackColor()
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.Center
        textField.font = UIFont(name: "PingFangTC-Regular", size: 16)
        // if there's empty in the textfield, then disable the return key.
        textField.enablesReturnKeyAutomatically = true

        // Init scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height*2)
        self.view.addSubview(scrollView)
        
        // Init the gameView and add it to viewcontroller
        let wordViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        gameView = wordView.init(frame: wordViewFrame)
        self.scrollView.addSubview(gameView)
        gameView.delegate = self
        
        // Init the tap gesture
        tapGes = UITapGestureRecognizer(target: self, action: "gameViewDidTapped:")
        gameView.addGestureRecognizer(tapGes)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func giveMeNewModel(sender: wordView) -> Array<Array<String>> {
        return wordArray
    }
    
    func gameViewDidTapped(sender: UITapGestureRecognizer){
        let location = sender.locationInView(gameView)
        
        // Calculate which row & column did tapped
        row = Int((location.x-10) / CGFloat((self.view.frame.width-20)/8))
        column = Int((location.y-25) / CGFloat((self.view.frame.height-35)/8))
        
        // Update the position of textField
        textField.frame.origin.x = CGFloat(row!) * CGFloat((self.gameView.frame.width-20)/8)+10
        textField.frame.origin.y = CGFloat(column!) * CGFloat((self.gameView.frame.height-35)/8)+25
        gameView.addSubview(textField)
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification){
        let userInfo: NSDictionary? = sender.userInfo
        let keyboardSize: CGSize = (userInfo?.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size)!
        let animateDuration: Double = Double((userInfo?.objectForKey(UIKeyboardAnimationDurationUserInfoKey))! as! NSNumber)
        
        // If textfield covered by keyboard, then scroll it!
        if textField.frame.origin.y + textField.frame.height > self.view.frame.height - keyboardSize.height{
            // Set the scrolling time duration the same as keyboard shows.
            UIView.animateWithDuration(animateDuration, animations: { () -> Void in
                self.scrollView.setContentOffset(CGPointMake(0, self.textField.frame.origin.y-keyboardSize.height+10), animated: true)
            })
        }
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = wordArray[column!][row!]
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        wordArray[column!][row!] = textField.text!
        gameView.setNeedsDisplay()
    }
    
    // This delegate method will called when you edit the textfield everytime.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        // replacementString is the new string that you insert
        // textField is the string that not changed yet
        let newString = (textField.text)! + string
        if newString.characters.count <= 1 {
            return true
        }else{
            return false
        }
        
        // Return true so the text field will be changed.
        return true
    }
    
    func keyboardWillHide(sender: NSNotification){
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        textField.removeFromSuperview()
    }

}

