//
//  ViewController.swift
//  Calculator
//
//  Created by Junor on 16/3/2.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var brain = CalculatorBrain()
    
    var middleTyping = false
    var isResult = false
    var numberOfPoint = 0
    
    // MARK: - Digit stuff
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." {
            ++numberOfPoint
        }

        if numberOfPoint <= 1 {
            if middleTyping {
                display.text = display.text! + digit
            } else {
                display.text = digit
                middleTyping = true
            }
        } else {
            --numberOfPoint
        }
    }
    
    @IBAction func deleteDigit() {
        if display.text!.characters.count >= 1 {
            display.text = String(display.text!.characters.dropLast())
            if display.text!.characters.count == 0 {
                display.text = "0"
            }
        }
    }
    
    // MARK: - Operate
    
    @IBAction func operate(sender: UIButton) {
       let operation = sender.currentTitle!
        
        if middleTyping {
            if operation == "ᐩ/-" {
                if display.text!.containsString("-") {
                   display.text = String(display.text!.characters.dropFirst())
                } else {
                    display.text = "-" + display.text!
                }
                return
            }
            enter()
        }
        
        displayValue = brain.performOperation(operation)
        
        updateHistoryUI()
        isResult = true
    }
    
    @IBAction func cleanEverything() {
        history.text = nil
        display.text = "0"
        cleanProperties()
        brain.cleanData()
    }

    func cleanProperties() {
        numberOfPoint = 0
        middleTyping = false
        isResult = false
    }
    
    // MARK: - Text Display
    
    @IBAction func enter() {
        displayValue = brain.pushOperand(displayValue)
        updateHistoryUI()
        cleanProperties()
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        } set {
            if let new = newValue {
                display.text = "\(new)"
            } else {
                display.text = nil
            }
            middleTyping = false
        }
    }
    
    
    func updateHistoryUI() {
        history.text = brain.description
    }
}

