////
////  Animate.swift
////  Coffee Champion
////
////  Created by Sathoshi Kumarawadu on 2016-04-22.
////  Copyright © 2016 Sathoshi Kumarawadu. All rights reserved.
////
//
//import UIKit
//
//class Animate: UIView, UIGestureRecognizerDelegate {
//
//    private var tapAndHold = UILongPressGestureRecognizer()
//    private var ringsView = UIView()
//    private var progress : CGFloat = 0.0
//    private var displayLink = CADisplayLink()
//    private var previousTimeStamp : Double = 0.0
//    private var locked : Bool = false;
//    @IBOutlet weak var progressBar: KDCircularProgress!
//    
//    struct constants{
//        
//        static let PROGRESS_DURATION_ENTER : NSTimeInterval = 1.0 // 1 second
//        static let PROGRESS_DURATION_EXIT: NSTimeInterval = 0.5 // 0.5 milli-seconds
//        static let PROGRESS_DURATION_DECAY : NSTimeInterval = 1 // should be 7200
//        static let ACTIVE_COLOR :  UIColor = UIColor(red: 0, green: 0.9098, blue: 0.149, alpha: 1.0)
//        static let LOCKED_COLOR : UIColor = UIColor(red: 0.8392, green: 0.5569, blue: 0, alpha: 1.0)
//        
//    }
//    
//    override init(frame:CGRect){
//        super.init(frame:frame)
//        setupGestureRecognizer()
//        
//        
//    }
//    
//    required init(coder aDecoder : NSCoder){
//        super.init(coder: aDecoder)!
//        setupGestureRecognizer()
//    }
//    
//    private func setupGestureRecognizer(){
//        
//        tapAndHold = UILongPressGestureRecognizer (target: self, action: "previewTappedAndHeld:")
//        tapAndHold.delegate = self
//        tapAndHold.minimumPressDuration = 0.0
//        tapAndHold.cancelsTouchesInView = false
//        self.addGestureRecognizer(tapAndHold)
//        
//    }
//    
//    func previewTappedAndHeld(recognizer : UITapGestureRecognizer){
//        
//        var counter = 0.0
//        
//        if recognizer.state == .Began {
//            
//            if locked == false{
//                
//            progressBar.setColors(constants.ACTIVE_COLOR)
//            progressBar.animateToAngle(360, duration: constants.PROGRESS_DURATION_ENTER, completion:nil)
//            }
//            
//
//            progress = 0.0
//            previousTimeStamp = 0.0
//            print("1")
//        }
//        
//        if recognizer.state == .Ended || recognizer.state == .Cancelled {
//            
//            progressBar.pauseAnimation()
//            print(progressBar.angle)
//            
//            if progressBar.angle >= 355.0 {
//                locked = true
//                progressBar.setColors(constants.LOCKED_COLOR)
//                progressBar.animateToAngle(0, duration: constants.PROGRESS_DURATION_DECAY,completion: nil)
//            }
//            
//            else {
//                
//                if progressBar.angle == 0.0{
//                    locked = false
//                }
//                
//                progressBar.animateToAngle(0, duration: constants.PROGRESS_DURATION_EXIT , completion: nil)
//            }
//            print("2")
//            }
//        }
//        
//    }
//    
//    func blah(param:Bool) -> Void{
//        print("inside")
//    }
//    
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
