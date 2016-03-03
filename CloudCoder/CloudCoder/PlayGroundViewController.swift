//
//  PlayGroundViewController.swift
//  SlideMenu
//
//  Created by KGISL-MAC on 23/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class PlayGroundViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var sourceCodeTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    var languageArray = ["C","C#","C++","JAVA","JAVASCRIPT","NODE.JS","OBJECTIVE C","PHP","PYTHON","RUBY","SCALA"]
    var selectedLanguage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
    }
    
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage = row
    }
    
    func languageId() -> Int{
        
        var langId = 0
        
        if(selectedLanguage == 0){
            langId = 11;        //C
        }else if(selectedLanguage == 1){
            langId = 27;        //C#
        }else if(selectedLanguage == 2){
            langId = 1          //C++
        }else if(selectedLanguage == 3){
            langId = 10         //JAVA  55
        }else if(selectedLanguage == 4){
            langId = 35         //JAVASCRIPT  112
        }else if(selectedLanguage == 5){
            langId = 56         //NODE.JS
        }else if(selectedLanguage == 6){
            langId = 43         //OBJECTIVE C
        }else if(selectedLanguage == 7){
            langId = 29         //PHP
        }else if(selectedLanguage == 8){
            langId = 4          //PYTHON   99 or 116
        }else if(selectedLanguage == 9){
            langId = 17         //RUBY
        }else if(selectedLanguage == 10){
            langId = 39         //SCALA
        }
        
        return langId
    }
    
    @IBAction func inputButtonTapped(sender: AnyObject) {
        
        errorTextView.hidden = true
        inputTextView.hidden = false
        resultTextView.hidden = true

        
    }
    @IBAction func errorButtonTapped(sender: AnyObject) {
        
        errorTextView.hidden = false
        inputTextView.hidden = true
        resultTextView.hidden = true
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //view.endEditing(true)
        errorTextView.hidden = true
        inputTextView.hidden = true
        resultTextView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        errorTextView.hidden = true
        inputTextView.hidden = true
        resultTextView.hidden = true
    }
    
    @IBAction func resultButtonTapped(sender: AnyObject) {
        
        errorTextView.hidden = true
        inputTextView.hidden = true
        resultTextView.hidden = false
        
    }
    
    @IBAction func runButtonTapped(sender: AnyObject) {
        
        
        errorTextView.hidden = true
        inputTextView.hidden = true
        resultTextView.hidden = false
        
        let sourceCode = sourceCodeTextView.text
        let language = languageId()
        let input = inputTextView.text
        
        print(language)
        
        
        //send data to server
        
        //let myUrl = NSURL(string: "http://10.100.9.105/vinoth/cloudcoder/cc_UserDetails.php")
        let myUrl = NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions?access_token=b51bccb64622752e4efe59d4ec9f1028")
        
        let request = NSMutableURLRequest(URL : myUrl!)
        
        request.HTTPMethod = "POST"
        
        let poststring = "language=\(language)&sourceCode=\(sourceCode)&input=\(input)";
        
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
                    
                    
                    
                    //------Start-----passing id--------
                    if let id = json["id"] as? String
                    {
                        self.passId(id);  //Function For passing id---From after submitting source code ---To pass id via URL for getting Result
                    }
                    //-----End--------passing id--------
                    
                    
                    
                }
                catch let error as NSError
                {
                    print(error)
                }
        };task.resume()
    }
    
    
    //************-----Passing id---after passing the source code ---To pass id via URL for getting Result-----************
    func passId(id : String)
    {
        
        var passingId : NSDictionary!
        do {
            let data = NSData(contentsOfURL: NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions/\(id)?access_token=b51bccb64622752e4efe59d4ec9f1028")!)
            passingId = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
        }
        catch{
            print(error)
        }
        
        print(passingId)
        
        sleep(5);
        
        
        //*********----To get result---- Id is passed with "withOutput=1"--**********
        var getOutput : NSDictionary!
        do {
            let data = NSData(contentsOfURL: NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions/\(id)?access_token=b51bccb64622752e4efe59d4ec9f1028&withSource=1&withInput=1&withOutput=1&withStderr=1&withCmpinfo=1")!)
            getOutput = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
        }
        catch{
            print(error)
        }
        
        print(getOutput)
        
        if let output = getOutput["output"] as? String
        {
            dispatch_async(dispatch_get_main_queue(), {  //Displa output in text view without conflict
                self.resultTextView.text =  (output)
            })
        }
        
        if let error = getOutput["stderr"] as? String
        {
            dispatch_async(dispatch_get_main_queue(), {  //Displa output in text view without conflict
                self.errorTextView.text =  (error)
            })
        }
        
        
        
    }
    
}
