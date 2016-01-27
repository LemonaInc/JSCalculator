//
//  ViewController.swift
//  JSCalculator
//
//  Created by Jaxon Stevens on 1/25/16.
//  Copyright © 2016 Jaxon Stevens. All rights reserved.
//


// Hello Zappos code reviewer, its nice to meet you! I was built by Jaxon Stevens.

// Thank you for taking the time to review my code, I know you probably recieve lots of applications.

// I thought this was the best way to set up a simple calculator, anyway I will leave you to it now. Enjoy!

import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    //Display
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var decimalButton: UIButton!
    

    

    //Start of old code
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Decimal = "."
        
    }
    
    // The sounds setup is here
    
    @IBOutlet weak var outputLbl: UILabel!
    
    // Sounds
    var btnSound: AVAudioPlayer!
    var clearSound: AVAudioPlayer!
    
    // Numbers
    var runningNumber = "0"
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    
    // The sounds are here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("Button", ofType: "mp3")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        let clearPath = NSBundle.mainBundle().pathForResource("Clicked", ofType: "mp3")
        let clearUrl = NSURL(fileURLWithPath: clearPath!)
        
        // Initial Number set to 0
        runningNumber = ""
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
            
            try clearSound = AVAudioPlayer(contentsOfURL: clearUrl)
            clearSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    
    // Clear Pressed
    @IBAction func clearPressed(sender: AnyObject) {
        clearSound.play()
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        outputLbl.text = "0"
        currentOperation = Operation.Empty

        
    }
    
    // Number Pressed
    @IBAction func numberPressed(btn: UIButton!) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
    
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    @IBAction func onDecimalPressed(Sender: AnyObject) {
        processOperation(Operation.Decimal)
        
    }
    
    // Process Operation
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            // Run some math
            
            // A user selected operator but then selected another
            // operator without fist entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                

            
                
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = op
            
        } else {
            // This is first time operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    // The Sounds Play Here
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }

}

