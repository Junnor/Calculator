//
//  GraphView.swift
//  Play
//
//  Created by Junor on 16/3/13.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit


protocol GraphViewDelegate: class {
    // Not set yet
}


@IBDesignable
class GraphView: UIView {
    
    weak var delegate: GraphViewDelegate?
    var axes = AxesDrawer(color: UIColor.purpleColor(), contentScaleFactor: 3.0)
    
    // for test
    @IBInspectable var color: UIColor = UIColor.purpleColor()
    
    @IBOutlet weak var formula: UILabel! {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        axes.drawAxesInRect(CGRect(center: center, size: CGSize(width: 500, height: 300)),
            origin: CGPoint(x: bounds.size.width / 2, y:  bounds.size.height / 2),
            pointsPerUnit: 50)
    }

}
