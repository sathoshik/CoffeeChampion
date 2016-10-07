//
//  ViewController.swift
//  Coffee Champion
//
//  Created by Sathoshi Kumarawadu on 2016-03-31.
//  Copyright © 2016 Sathoshi Kumarawadu. All rights reserved.
//
// UI/Animation goes in here.

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let urlDrink = "http://192.168.2.85/CoffeeChampion/api/drink";
    let urlDrinkCount = "http://192.168.2.85/CoffeeChampion/api/getDrinkCount/user/" + String(NSUserDefaults.standardUserDefaults().integerForKey("userID"));
    
    private var tapAndHold = UILongPressGestureRecognizer();
    private var progress : CGFloat = 0.0;
    private var displayLink = CADisplayLink();
    private var previousTimeStamp : Double = 0.0
    
    
    //let urlDrink = "http://69.157.32.137/CoffeeChampion/api/drink";
    //let urlDrinkCount = "http://69.157.32.137/CoffeeChampion/api/getDrinkCount/user/" + String(NSUserDefaults.standardUserDefaults().integerForKey("userID"));
    
    //@IBOutlet weak var CoffeeCount: UILabel!
    
    var count:Int! = 0;

    /*
    @IBAction func PressAction(sender: AnyObject) {
        
        let userID = NSUserDefaults.standardUserDefaults().integerForKey("userID");
        
        if sender.state == UIGestureRecognizerState.Cancelled{
            print("2");
            
        }
        
        if sender.state == UIGestureRecognizerState.Ended{
            print("3")
        }
        
        if sender.state == UIGestureRecognizerState.Recognized{
            print("4")
        }
        
        if sender.state == UIGestureRecognizerState.Began
        {
            print("1");
            //Do a DB Call  - > update coffee count on the backend
            //              - > Check the last time a coffe was drank. See if its reasonable or just straight pressing
            //              - > If valid
            //                     -> Increment, Return coffee count
            //              - > Else
            //                     -> Display Message saying LOL, Stop lying now
            //increaseCoffeeCount(userID);
            /*
            drinkCoffee(userID){
                returnValue in
                
                if let returnValue = returnValue{
                    
                    if(returnValue > 0){
                        self.count!++;
                    }   
                    else{
                    
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    self.displayAlertMessage("Hey!, Champions don't lie. It's hard to believe you drank more than 1 cup of coffee within 2 hours!", alertTitle: "Ummm...")
                    
                    
                    });
                    }
                    
                    self.CoffeeCount.text = String(self.count);

                    
                }
                
                
                
            }
            
            self.CoffeeCount.text = String(count);
 
            
            let ovalStartAngle = CGFloat(90.1 * M_PI/180)
            let ovalEndAngle = CGFloat(90*M_PI/180)
            let ovalRect = CGRectMake(97.5, 58.5, 125, 125)
            
            let ovalPath = UIBezierPath();
            
            ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(ovalRect),CGRectGetMidY(ovalRect)),
                                      radius: CGRectGetWidth(ovalRect) / 2,
                                      startAngle : ovalStartAngle,
                                      endAngle : ovalEndAngle , clockwise:true )
            
            
            let progressLine = CAShapeLayer();
            progressLine.path = ovalPath.CGPath
            progressLine.strokeColor = UIColor.whiteColor().CGColor
            progressLine.fillColor = UIColor.clearColor().CGColor
            progressLine.lineWidth = 10.0
            progressLine.lineCap = kCALineCapRound
            
            self.view.layer.addSublayer(progressLine)
            
            let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            animateStrokeEnd.duration = 1.0
            animateStrokeEnd.fromValue = 0
            animateStrokeEnd.toValue = 1.0
            
            progressLine.addAnimation(animateStrokeEnd, forKey : "animate stroke end animation")
   */
            
            

            
            
 }
    }

 */
 override func viewDidLoad() {
        super.viewDidLoad()
        getDrinkCount(){
            responseValue in
            
            if let responseValue=responseValue{
                print(responseValue);
                self.count = responseValue;
                //self.CoffeeCount.text = String(self.count);
            }
        };
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
        //NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if(!isUserLoggedIn){
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }


    func drinkCoffee(userID:Int,completionHandler:(Int?) -> Void){
        
        let parameters = ["UserID":userID];
        var responseValue = 0;
        
        Alamofire.request(.POST,urlDrink,parameters:parameters,encoding:.JSON)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .Success:
                    responseValue =  1;
                    completionHandler(responseValue);
                    
                case .Failure(let error):
                    
                    responseValue = 0;
                    completionHandler(responseValue);
                }
        }
        
    }
    
    
    
    func getDrinkCount(completionHandler:(Int?) -> Void){
        
        var responseValue = 0;
        
        Alamofire.request(.GET,urlDrinkCount)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .Success(let JSON):
                    if let jsonResult = JSON as? Dictionary<String,String>{
                        responseValue = Int(jsonResult["returnValue"]!)!;
                        completionHandler(responseValue);
                    }
                case .Failure(let error):
                    completionHandler(responseValue);
                
                }
        }
    }
    
    
    
    
    func displayAlertMessage(message:String,alertTitle:String){
        
        var alert = UIAlertController(title: alertTitle, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
        
        alert.addAction(okAction);
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    

    
    
    
    


}
