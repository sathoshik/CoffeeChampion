//
//  ViewController.swift
//  Coffee Champion
//
//  Created by Sathoshi Kumarawadu on 2016-03-31.
//  Copyright © 2016 Sathoshi Kumarawadu. All rights reserved.

/*
 localhost/coffeechampion/api/getDrinkCount/user/5
 [
    {
        "CoffeeCount": 16,
        "Attribute": "ROOKIE",
        "Target": 4,
        "Progress": 0
    }
 ]
 
 
 
 localhost/coffeechampion/api/getLevel/user/5
 [
    {
        "Attribute": "ROOKIE",
        "Target": 4
    }
 ]
 
 */

import UIKit
import Alamofire
import AudioToolbox



class ViewController: UIViewController {
    
    //let urlDrink = "http://192.168.2.85/CoffeeChampion/api/drink";
    //let urlDrinkCount = "http://192.168.2.85/CoffeeChampion/api/getDrinkCount/user/" + String(NSUserDefaults.standardUserDefaults().integerForKey("userID"));
    
    private var locked : Bool = true
    let userID = NSUserDefaults.standardUserDefaults().integerForKey("userID")
    
    @IBOutlet weak var TargetLabel: UILabel!
    @IBOutlet weak var CoffeeCount: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var progressBar: KDCircularProgress!
    
    let urlDrink = "http://sathoshik.com/CoffeeChampion/api/drink"
    let urlDrinkCount = "http://sathoshik.com/CoffeeChampion/api/getDrinkCount/user/" + String(NSUserDefaults.standardUserDefaults().integerForKey("userID"));
    let urlUpdate = "http://sathoshik.com/CoffeeChampion/api/getLevel/user/" + String(NSUserDefaults.standardUserDefaults().integerForKey("userID"));
    
    struct constants{
        
        static let PROGRESS_DURATION_ENTER : NSTimeInterval = 1.0 // 1 second
        static let PROGRESS_DURATION_EXIT: NSTimeInterval = 0.5 // 0.5 milli-seconds
        static let PROGRESS_DURATION_DECAY : NSTimeInterval = 7200 // should be 7200
        static let ACTIVE_COLOR :  UIColor = UIColor(red: 0, green: 0.9098, blue: 0.149, alpha: 1.0) //green
        static let LOCKED_COLOR : UIColor = UIColor(red: 0.9569, green: 0.7804, blue: 0, alpha: 1.0) //yellow
    }
    
    struct ChampionData{
        
        var attribute:String = "";
        var coffeeCount:Int = 0;
        var progress:Int = 0;
        var target:Int = 0;
        
    }
    
    struct UpdateChampionData{
        var attribute:String = "";
        var target:Int = 0;
    }
    
    var count:Int! = 0;
    

 func handleLongPress(recognizer: UILongPressGestureRecognizer) {
    //var count = 0.0
    
            if recognizer.state == .Began {
    
                if locked == false{
    
                progressBar.setColors(constants.ACTIVE_COLOR)
                progressBar.animateToAngle(360, duration: constants.PROGRESS_DURATION_ENTER, completion:nil)
                }
    
    
            }
    
            if recognizer.state == .Ended || recognizer.state == .Cancelled {
    
                if locked == false{
                progressBar.pauseAnimation()
    
                if progressBar.angle >= 355.0 {
                    locked = true
                    
                    drinkCoffee(userID){
                        returnValue in
                        
                        if let returnValue = returnValue{
                            
                            self.count = Int(self.CoffeeCount.text!)
                            
                            if(returnValue > 0){
                                self.count!++;
                            }
                            else{
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    self.displayAlertMessage("Hey!, Champions don't lie. It's hard to believe you drank more than 1 cup of coffee within 2 hours!", alertTitle: "Ummm...")
                                    
                                    
                                });
                            }
                            
                            self.CoffeeCount.text = String(self.count);
                            
                            self.getCallBack(){
                                responseValue in
                                
                                if let responseValue=responseValue{
                                    
                                    
                                   
                                    self.TargetLabel.text = String(responseValue.target) + " MORE DRINKS TO LEVEL UP"
                                    
                                    self.StatusLabel.text = String(responseValue.attribute)
                                    
                                    
                                    //self.count = responseValue;
                                    //self.CoffeeCount.text = String(self.count);
                                }
                            };

                            
                            
                        }
                    }
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                    
                    progressBar.setColors(constants.LOCKED_COLOR)
                    progressBar.animateToAngle(0, duration: constants.PROGRESS_DURATION_DECAY,completion: {(value:Bool) in
                        self.locked = false
                    })
                }
    
                else {
    
                 
                    progressBar.animateToAngle(0, duration: constants.PROGRESS_DURATION_EXIT , completion: nil)
                    
                }
                }
    }
    

 }
 
 override func viewDidLoad() {
        super.viewDidLoad()
    
    let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
    lpgr.minimumPressDuration = 0
    lpgr.delaysTouchesBegan = true
    self.view.addGestureRecognizer(lpgr)
    
    
        getDrinkCount(){
            responseValue in
            
            if let responseValue=responseValue{
                
                
                self.progressBar.angle = Double(responseValue.progress)
                self.progressBar.setColors(constants.LOCKED_COLOR)
                self.progressBar.animateToAngle(0, duration: ((Double(responseValue.progress)*constants.PROGRESS_DURATION_DECAY)/360), completion: {(value:Bool) in
                    self.locked = false
                })
                
                self.CoffeeCount.text = String(responseValue.coffeeCount)
                self.StatusLabel.text = String(responseValue.attribute)
                self.TargetLabel.text = String(responseValue.target) + " MORE DRINKS TO LEVEL UP"
                
                //self.count = responseValue;
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
    
    
    
    func getDrinkCount(completionHandler:(ChampionData?) -> Void){
        
        var attribute:String = "";
        var coffeeCount:Int = 0;
        var progress:Int = 0;
        var target:Int = 0;
        
        Alamofire.request(.GET,urlDrinkCount)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .Success(let JSON):
                    
                    if let jsonResult = JSON as? Dictionary<String,String>{
                        

                        attribute = jsonResult["Attribute"]!;
                        coffeeCount = Int(jsonResult["CoffeeCount"]!)!;
                        progress = Int(jsonResult["Progress"]!)!;
                        target = Int(jsonResult["Target"]!)!;
                        
                        
                        var data = ChampionData(attribute: attribute, coffeeCount: coffeeCount, progress: progress, target: target)
                        
                        completionHandler(data);
                    }
                case .Failure(let error):
                    print("fuck")
                    //ompletionHandler(data);
                
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

    
    
    func getCallBack(completionHandler:(UpdateChampionData?) -> Void){
        
  
        var attribute:String = "";
        var target:Int = 0;
        
        Alamofire.request(.GET,urlUpdate)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .Success(let JSON):
                    
                    if let jsonResult = JSON as? Dictionary<String,String>{
                        
                        
                        attribute = jsonResult["Attribute"]!;
                        target = Int(jsonResult["Target"]!)!;
                        
                        
                        var data = UpdateChampionData(attribute: attribute,target: target)
                        
                        completionHandler(data);
                    }
                case .Failure(let error):
                    print("fuck")
                    //ompletionHandler(data);
                    
                }
        }
    }


    
    
    
    


}
