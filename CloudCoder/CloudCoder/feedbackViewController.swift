//
//  feedbackViewController.swift
//  CloudCoder
//
//  Created by KGISL-MAC on 26/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class feedbackViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        
        let fName = nameTextField.text
        let fEmail = emailTextField.text
        let fComment = commentTextView.text
        
        if( fName == "" && fEmail == "" && fComment == "") {
            dispalyMessage("All fields are mandatory!")
        }else if fName == "" {
            dispalyMessage("Name field is required!");
        }else if fEmail == "" {
            dispalyMessage("Email field is required!");
        }else if fComment == ""{
            dispalyMessage("Comment is required!");
        }else if  !isValidEmail(fEmail!){
            dispalyMessage("Enter valid Email!");
        }

        else{
            

            //send data to server
            
            //let myUrl = NSURL(string: "http://10.100.9.105/vinoth/cloudcoder/cc_UserDetails.php")
            let myUrl = NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions?access_token=b51bccb64622752e4efe59d4ec9f1028")
            
            let request = NSMutableURLRequest(URL : myUrl!)
            
            request.HTTPMethod = "POST"
            
            let poststring = "name=\(fName)&email=\(fEmail)&comment=\(fComment)";
            
            request.HTTPBody = poststring.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
                {
                    
                    data, response, error -> Void in
                    
                    if (error != nil)
                    {
                        print("error=\(error)")
                        return
                    }
                    
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                        print("ID For the cod or error : \(json)")
                        
                        
                        let resultValue = json["status"] as! String;
                        print("Result: \(resultValue)")

                        
                        if(resultValue=="Success"){
                            self.dispalyMessage("Comment posted successfully!")
                        }
                        
                        
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
            };task.resume()
            
            
        }
    }
    
    func dispalyMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil );
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion : nil );
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        //print("validate emilId: \(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        print(result)
        
        return result
    }


}
