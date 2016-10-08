//  LoginViewController.swift
//  Coffee Champion
//
//  Created by Sathoshi Kumarawadu on 2016-04-01.
//  Copyright © 2016 Sathoshi Kumarawadu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ContinueButtonTapped(sender: AnyObject) {
        
        let username = usernameTextField.text!;
        
        //check for empty fields.
        
        if(username.isEmpty ){
            
            //If username is empty, display alert message prompting user to enter username
            
            displayAlertMessage("Please enter a username",alertTitle:"Oops");
            return;
        }
        
        //check if the username is a valid username -> this will be from the backened

      
        ValidateUserNameDB(username){
            returnValue, error in
            if let returnValue = returnValue{
                
                print (returnValue);
                
                if(returnValue != -1){
                    
                    //If the username is not already in the database, Store data on your local phone
                    //It is important to note that the user will only have one way access. There is no way to login in as someone else. One username per person/per phone/ per login
                    
                    NSUserDefaults.standardUserDefaults().setObject(username,forKey: "username");
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn");
                    NSUserDefaults.standardUserDefaults().setInteger(returnValue, forKey: "userID");
                    NSUserDefaults.standardUserDefaults().synchronize();
                
                    self.dismissViewControllerAnimated(true, completion: nil);
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    self.displayAlertMessage("Username is already in use", alertTitle: "Sorry")
                    
                    
                    });
                    
                }
            }
            else{
                print(error);
            }
        };
    }
    
    //diplay alert function
    func displayAlertMessage(message:String,alertTitle:String){
        
        var alert = UIAlertController(title: alertTitle, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
        
        alert.addAction(okAction);
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func ValidateUserNameDB(username:String,completionHandler:(Int?,NSError?) -> Void){
        
        //Construct Json Data
        
        let json = [ "username":username ]
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
        
        
        //Construct web Request
        let URLPath = "http://192.168.2.85/CoffeeChampion/api/champion/register"
        //let URLPath = "http://69.157.32.137/CoffeeChampion/api/champion/register"
        let URL = NSURL(string: URLPath);
        
        let request = NSMutableURLRequest(URL:URL!);
        request.HTTPMethod = "POST";
        request.HTTPBody = jsonData;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 6000;
        request.HTTPShouldHandleCookies=false;
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
        
            data, response, error in
            
            guard data != nil else{
                print ("no data found:\(error)")
                return
            }
            
            do{
                
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary;
                
                if let parseJSON = json {
                    
                    var result:String = parseJSON["returnValue"] as! String;
                    let returnValue : Int! = Int(result);
                    
                    completionHandler(returnValue,nil)
                    return
                }
            }
            catch let error as NSError{
                print("something went wrong");
                completionHandler(nil,error)
            }
        }
        
        task.resume()
    }
}
