//
//  ViewController.swift
//  RetroCalculator
//
//  Created by AAJM van Montfort on 29-01-17.
//  Copyright © 2017 AAJM van Montfort. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }

    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var resultValStr = ""

    @IBOutlet weak var outputLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let path = Bundle.main.path(forResource: "btn", ofType: "wav") {
            let soundURL = URL(fileURLWithPath: path)
            
            do {
                try btnSound = AVAudioPlayer(contentsOf: soundURL)
                btnSound.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
        }
        
        outputLbl.text = "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func DivideBtnPressed(_ sender: Any) {
        processOperation(operation: Operation.Divide)
    }

    @IBAction func MultiplyBtnPressed(_ sender: Any) {
        processOperation(operation: Operation.Multiply)
    }
   
    @IBAction func SubtractBtnPressed(_ sender: Any) {
        processOperation(operation: Operation.Subtract)
    }
    
    @IBAction func AddBtnPressed(_ sender: Any) {
        processOperation(operation: Operation.Add)
    }
    
    @IBAction func EqualBtnPressed(_ sender: Any) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func ClearBtnPressed(_ sender: Any) {
        clear()
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }

        btnSound.play()
    }
    
    func clear() {
        currentOperation = Operation.Empty
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        resultValStr = ""
        
        outputLbl.text = "0"
    }
    
    func processOperation(operation: Operation) {
        playSound()
        
            //Check if user pressed an operator
            if currentOperation != Operation.Empty {
                
                // Check if user pressed operator without pressing a number first
                if runningNumber != "" {
                    rightValStr = runningNumber
                    
                    if leftValStr != "" {
                        if currentOperation == Operation.Divide {
                            resultValStr = "\(Double(leftValStr)! / (Double(rightValStr))!)"
                        } else if currentOperation == Operation.Multiply {
                            resultValStr = "\(Double(leftValStr)! * (Double(rightValStr))!)"
                        } else if currentOperation == Operation.Subtract {
                            resultValStr = "\(Double(leftValStr)! - (Double(rightValStr))!)"
                        } else if currentOperation == Operation.Add {
                            resultValStr = "\(Double(leftValStr)! + (Double(rightValStr))!)"
                        }
                        leftValStr = resultValStr
                        outputLbl.text = resultValStr
                    } else {
                        leftValStr = runningNumber
                        outputLbl.text = leftValStr
                    }
                    runningNumber = ""
                }
                currentOperation = operation
            } else {
                //First time the operator has been pressed
                leftValStr = runningNumber
                runningNumber = ""
                currentOperation = operation
                
            }
        
    }
}

