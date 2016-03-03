//
//  loginPageViewController.swift
//  login
//
//  Created by KGISL-MAC on 16/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class loginPageViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let username = userNameTextField.text
        let password = passwordTextField.text
        
        if username == "" && password == ""
        {
            dispalyMessage("All fields are required!")

        }else if username == ""
        {
            dispalyMessage("Username required");
        }else if password == ""
        {
            dispalyMessage("Password required");
        }
        
        //Send user data to server
        
        let myUrl = NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/Login.php?");
        //        let myUrl = NSURL(string: "http://vinoth.uboxi.com/login/userLogin.php")
        let request = NSMutableURLRequest(URL : myUrl!);
        request.HTTPMethod = "POST";
        
//        let postString = "username=\(username!)&password=\(password!)";
        let postString = "username=\(username!)";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                data, response, error -> Void in
                
                if (error != nil)
                {
                    print("error=\(error)")
                    return
                }
                
                //--Start-->For display message in json
                do
                {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    
                    print("json: \(json)");
                    
                    let resultValue:String = json["status"] as! String;
                    print("Result: \(resultValue)")
                    
             
                    if(resultValue == "Success")
                    {
                        
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "isUserLogged")
                        prefs.synchronize()
                        
                        
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        sleep(3)
                        
                    }
                }
                catch let error as NSError
                {
                    print(error)
                }
        };
        //--End-->For display message in json
        
        task.resume();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dispalyMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil );
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion : nil );
    }


}
