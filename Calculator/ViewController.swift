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
    
    var middleTyping: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if middleTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            middleTyping = true
        }
    }

}

