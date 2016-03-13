//
//  GraphViewController.swift
//  Play
//
//  Created by Junor on 16/3/11.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "pinchAction:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "panAction:"))
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: "tapAction:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)

        }
    }
    
}


// MARK: - GraphViewDelegate

extension GraphViewController: GraphViewDataSource {
    
    // 每个 x -> y
    func y(x: CGFloat) -> CGFloat? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            return CGFloat(y)
        }
        return nil
    }
    
}

