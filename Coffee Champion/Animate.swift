//
//  Animate.swift
//  Coffee Champion
//
//  Created by Sathoshi Kumarawadu on 2016-04-22.
//  Copyright © 2016 Sathoshi Kumarawadu. All rights reserved.
//

import UIKit

class Animate: UIView, UIGestureRecognizerDelegate {

    private var tapAndHold = UILongPressGestureRecognizer()
    private var ringsView = UIView()
    private var progress : CGFloat = 0.0
    private var displayLink = CADisplayLink()
    private var previousTimeStamp : Double = 0.0
    
    struct constants{
        
        static let PROGRESS_DURATION : CGFloat = 5.0
        
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        setupGestureRecognizer()
        
    }
    
    required init(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)!
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer(){
        
        tapAndHold = UILongPressGestureRecognizer (target: self, action: "previewTappedAndHeld:")
        tapAndHold.delegate = self
        tapAndHold.minimumPressDuration = 0.0
        tapAndHold.cancelsTouchesInView = false
        self.addGestureRecognizer(tapAndHold)
        
    }
    
    func previewTappedAndHeld(recognizer : UITapGestureRecognizer){
        
        if recognizer.state == .Began {
            progress = 0.0
            previousTimeStamp = 0.0
            print("1")
        }
        
        if recognizer.state == .Ended || recognizer.state == .Cancelled {
            ringsView.removeFromSuperview()
            ringsView = UIView()
            displayLink.invalidate()
            print("2")
        }
        
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if let touch = event!.touchesForGestureRecognizer(tapAndHold)!.first {
            let progressIndicatorViewRect : CGRect = frameForTouch(touch)
            self.createRingsWithTouchFrame(progressIndicatorViewRect)
        }
    
        

    }
    
    private func frameForTouch(touch: UITouch) -> CGRect{
        let touchLocation : CGPoint = touch.locationInView(self)
        
        let os = NSProcessInfo().operatingSystemVersion
        let touchDiameter : CGFloat = (os.majorVersion == 8 ) ? max((touch.majorRadius * 2.25),100) :100
        return CGRect(x:touchLocation.x , y : touchLocation.y , width : touchDiameter, height: touchDiameter)
        
        
    }
    
    
    private func createRingsWithTouchFrame(touchFrame : CGRect){
        ringsView.frame = CGRect(x:0,y:0,width: touchFrame.width * 5 , height: touchFrame.width * 5)
        ringsView.center = CGPoint(x:touchFrame.origin.x,y:touchFrame.origin.y)
        
        CGRectMake(self.frame.size.width/2 - touchFrame.width/2, self.frame.size.height/2 - touchFrame.height/2, touchFrame.width, touchFrame.height);
        
        
        
        let ovalStartAngle = CGFloat(90.1 * M_PI/180)
        let ovalEndAngle = CGFloat(90*M_PI/180)
        //let ovalRect = CGRectMake(97.5, 58.5, 125, 125)
        
        let ovalPath = UIBezierPath();
        
        ovalPath.addArcWithCenter(CGPoint(x:touchFrame.origin.x,y:touchFrame.origin.y),
                                  radius: touchFrame.width,
                                  startAngle : ovalStartAngle,
                                  endAngle : ovalEndAngle , clockwise:true )
        
        
        let progressLine = CAShapeLayer();
        progressLine.path = ovalPath.CGPath
        progressLine.strokeColor = UIColor.whiteColor().CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = 10.0
        progressLine.lineCap = kCALineCapRound
        
        ringsView.layer.addSublayer(progressLine)
        //ringsView.addSubview(<#T##view: UIView##UIView#>)
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 1.0
        animateStrokeEnd.fromValue = 1.0
        animateStrokeEnd.toValue = 0
        progressLine.addAnimation(animateStrokeEnd, forKey : "animate stroke end animation")
        
        self.showRingAndUpdateProgress()
    }
    
    private func showRingAndUpdateProgress(){
        //ringsView.alpha = 0.0
        
        self.addSubview(ringsView)
        
        displayLink = CADisplayLink(target: self, selector: "updateProgress")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    
    func updateProgress(){
        if previousTimeStamp == 0.0 {
            previousTimeStamp = displayLink.timestamp
            return
        }
        
        if progress < 1.0 {
            progress = progress + CGFloat(displayLink.timestamp - previousTimeStamp)
        }
    }
    
}



























