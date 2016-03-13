//
//  GraphView.swift
//  Play
//
//  Created by Junor on 16/3/13.
//  Copyright © 2016年 Junor. All rights reserved.
//

import UIKit


protocol GraphViewDataSource: class {
    
    func pointsForGraphView(sender: GraphView) -> [CGPoint]
    
}


@IBDesignable class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    var viewCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var axesOrigin: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            updateInfo()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var scale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func updateInfo() {
    }
        
    override func awakeFromNib() {
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "pinchAction:"))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panAction:"))
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "tapAction:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapRecognizer)
    }

    override func drawRect(rect: CGRect) {
        let axes = AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: scale)
        axes.drawAxesInRect(bounds, origin: axesOrigin, pointsPerUnit: 50)
    }
    
    
    // MARK: - Gesture Aaction
    
    func pinchAction(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .Changed {
            scale *= recognizer.scale
            recognizer.scale = 1.0
        }
    }
    
    func panAction(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Ended: fallthrough
        case .Changed:
            axesOrigin = recognizer.locationInView(self)
        default: break
        }
    }
    
    func tapAction(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            axesOrigin = recognizer.locationInView(self)
        }
    }

}
