//
//  sourcePageViewController.swift
//  CC_TableView
//
//  Created by KGISL-MAC on 12/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class sourcePageViewController:  BaseViewController {

    @IBOutlet weak var sourceCodeTextView: UITextView!
    
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var pid : String!
    var language_id : String!
    var userId :String!
    
    
    override func viewDidAppear(animated: Bool) {
        self.addSlideMenuButton()
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.addSlideMenuButton()
        
        //------Get source code to TextView
        var sourceCode : NSDictionary!
        do {
            userId = prefs.valueForKey("SESSIONID") as? String
            
            print("User id = \(userId)")
            
            let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/GetSourceCode.php?userId=\(userId)&problemId=\(pid)")!)
            sourceCode = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
        }
        catch{
            print(error)
        }
        
        if let result = sourceCode["text"] as? String
        {
            dispatch_async(dispatch_get_main_queue(), {  //Displa output in text view without conflict
               self.sourceCodeTextView.text =  (result)
            })
        }
        
        if let eventId = sourceCode["event_id"] as? String
        {
            dispatch_async(dispatch_get_main_queue(), {  //Displa output in text view without conflict
                print(eventId)
            })
        }
        
        //------Get Language Id from cc_problems(Problem Type)
        var problem_type : NSDictionary!
        do {
            
            let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/GetLanguageId.php?problemId=\(pid)")!)
            problem_type = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
        }
        catch{
            print(error)
        }
        
        let prblm_type = problem_type["problem_type"] as? String
        //print(prblm_type)
        
        if prblm_type == "2" || prblm_type == "3" {         //For "C"
            language_id = "11"
        }
        else if prblm_type == "6" || prblm_type == "7" {    //For "C++"
            language_id = "1"
        }
        else if prblm_type == "0" || prblm_type == "4" {    //For "JAVA"
            language_id = "10"              //Or use "55"
        }
        else if prblm_type == "1" {                         //For "PYTHON"
            language_id = "4"               //Or use "99"
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resetBtnTapped(sender: AnyObject) {
        
        var Skeleton : NSDictionary!
        do {
            
            let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/GetSkeleton.php?problemId=\(pid)")!)
            Skeleton = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
        }
        catch{
            print(error)
        }
        
        if let result = Skeleton["skeleton"] as? String
        {
            dispatch_async(dispatch_get_main_queue(), {  //Displa output in text view without conflict
                self.sourceCodeTextView.text =  (result)
            })
        }

        
    }
    
    @IBAction func submitBtnTapped(sender: AnyObject) {

        let submitData = sourceCodeTextView.text
        
        //------------------------------------------------To get ccTestCasesInput with TestCaseID-----------------------------------------------------
        var ccTestCases : NSArray!
        do {
            let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/TestCase.php?problemId=\(pid)")!)
            ccTestCases = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
            
        }
        catch{
            print(error)
        }
        
        //print(cc_test_cases)
        
        //------To get test_case_Id[]
        var testCaseName : Array<String> = []
        for (index,element) in ccTestCases.enumerate() {
            if (index % 2 == 0){
                testCaseName.append(element as! String)
            }
        }
        //print("test_case_name = \(test_case_name)")
        
        //------To get input[]
        var inputArray : Array<String> = []
        for (index,element) in ccTestCases.enumerate() {
            if (index % 2 != 0){
                inputArray.append(element as! String)
            }
        }
        print("inputArray = \(inputArray)")
        
        
        
        //------------------------------------------------To get ccTestCaseOutput with TestCaseID-----------------------------------------------------
        var ccTestCaseOutput : NSArray!
        do {
            let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/TestCaseOutput.php?problemId=\(pid)")!)
            ccTestCaseOutput = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
            
        }
        catch{
            print(error)
        }
        
        //print(ccTestCaseOutput)
        
        //------To get output[]
        var outputArray : Array<String> = []
        for (index,element) in ccTestCaseOutput.enumerate() {
            if (index % 2 != 0){
                outputArray.append(element as! String)
            }
        }
        print("outputArray = \(outputArray)")

        
        
        
       
        let lengthOfTestCases = inputArray.count
        
        print(lengthOfTestCases)
        
        var passedTestCaseArray : Array<String> = []
        var failedTestCaseArray : Array<String> = []

        
        //------For loop for Test_cases
        for (var i = 0; i < lengthOfTestCases; i++)
        {
   
            let input = inputArray[i]
            let ccOutput = outputArray[i]
            let tCaseName = testCaseName[i]
            
            print("input = \(input)")

            //send data to server
            
            let myUrl = NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions?access_token=b51bccb64622752e4efe59d4ec9f1028")
            
            let request = NSMutableURLRequest(URL : myUrl!)
            
            request.HTTPMethod = "POST"
            
            let poststring = "language=\(language_id)&sourceCode=\(submitData)&input=\(input)";
            
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
                            
                        //************-----Passing id---after passing the source code ---To pass id via URL for getting Result-----************
                            var passingId : NSDictionary!
                            do {
                                let data = NSData(contentsOfURL: NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions/\(id)?access_token=b51bccb64622752e4efe59d4ec9f1028")!)
                                passingId = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                                
                            }
                            catch{
                                print(error)
                            }
                            print(passingId)
                            
                            sleep(5);       //delay for getting output***********
                            
                        //*********----To get result---- Id is passed with "withOutput=1"--**********
                            var Response : NSDictionary!
                            do {
                                let data = NSData(contentsOfURL: NSURL(string: "http://api.compilers.sphere-engine.com/api/v3/submissions/\(id)?access_token=b51bccb64622752e4efe59d4ec9f1028&withSource=1&withInput=1&withOutput=1&withStderr=1&withCmpinfo=1")!)
                                Response = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                                
                            }
                            catch{
                                print(error)
                            }
                            
                            print(Response)
                            
                            let seOutput = Response["output"] as? String
                            
                            print(seOutput)


                            //-----Validate the output with testCaseOutput-----
                            if seOutput == ccOutput{
                                passedTestCaseArray.append(tCaseName)
                                failedTestCaseArray.append(seOutput!)

                                //print("passed test cases = \(passedTestCaseArray)")

                            }
                            else{
//                                failedTestCaseArray.append(tCaseName)
                                //print("Failed test cases = \(failedTestCaseArray)")

                            }

                        }
                        //-----End--------passing id--------
          
                        
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
            };task.resume()
            
            
            sleep(10)
            
            
        }
        
        print("Passed Testcases = \(passedTestCaseArray)")
        print("Passed Testcase results = \(failedTestCaseArray)")
        

        
    }
    
    
    

}

/*
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
        
        sleep(5);       //delay for getting output***********
        
        
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
            print("\(output)")
        }
    
    }

*/*/*/
