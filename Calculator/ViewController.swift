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
    
    var middleTyping = false
    var isResult = false
        
    var numberOfPoint = 0
    var operation: String?
    
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
        operation = sender.currentTitle!
        
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
        
        isResult = true
        
        switch operation! {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0)}
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { $0 * M_PI }
        case "%": performOperation{ $0 / 100 }
        case "ᐩ/-": performOperation { -$0 }
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func cleanEverything() {
        history.text = nil
        display.text = "0"
        middleTyping = false
        isResult = false
        numberOfPoint = 0
        operation = nil
        operandStack.removeAll()
    }

    // MARK: - Text Display
    
    var operandStack = [Double]()
    
    @IBAction func enter() {
        
        if let newValue = displayValue {
            operandStack.append(newValue)
        } else {
            display.text = nil
        }
        print("operation stack = \(operandStack)")
        
        if history.text!.containsString("=") {
            history.text = String(history.text!.characters.dropLast())
        }

        if !operandStack.isEmpty && !isResult {
            addToHistory(String(operandStack.last!))
        }

        if !operandStack.isEmpty && operation != nil && isResult {
            addToHistory(operation!)
            addToHistory("=")
        }
        
        numberOfPoint = 0
        middleTyping = false
        isResult = false
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
    
    func addToHistory(str: String) {
        if let text = history.text {
            history.text! = text + " \(str)"
        } else {
            history.text = str
        }
    }
    
}

