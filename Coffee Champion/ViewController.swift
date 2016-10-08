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
    
    var count:Int! = 0;

 override func viewDidLoad() {
        super.viewDidLoad()
        getDrinkCount(){
            responseValue in
            
            if let responseValue=responseValue{
                print(responseValue);
                self.count = responseValue;
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
