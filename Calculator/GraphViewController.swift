//
//  GraphViewController.swift
//  Play
//
//  Created by Junor on 16/3/11.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var formulaDescription: String = "formula"
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.delegate = self
            graphView.formula.text = formulaDescription
        }
    }
    
}


// MARK: - GraphViewDelegate

extension GraphViewController: GraphViewDelegate {
    // Not implement yet
}

