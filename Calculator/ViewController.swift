//
//  ViewController.swift
//  Calculator
//
//  Created by Junor on 16/3/2.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var middleTyping = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if middleTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            middleTyping = true
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if middleTyping {
            enter()
        }
        
        switch operation {
           
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0)}
            
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

    
    var operandStack = [Double]()
    @IBAction func enter() {
        middleTyping = false
        operandStack.append(displayValue)
        print("operation stack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        } set {
            display.text = "\(newValue)"
            middleTyping = false
        }
    }
    

}

