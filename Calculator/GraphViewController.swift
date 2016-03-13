//
//  GraphViewController.swift
//  Play
//
//  Created by Junor on 16/3/11.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var formulaDescription: String = "" {
        didSet {
            title = "y = " + formulaDescription
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
}


// MARK: - GraphViewDelegate

extension GraphViewController: GraphViewDataSource {
    
    func pointsForGraphView(sender: GraphView) -> [CGPoint] {
        return []
    }
}

