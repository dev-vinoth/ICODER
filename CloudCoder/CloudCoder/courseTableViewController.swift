//
//  courseTableViewController.swift
//  login
//
//  Created by KGISL-MAC on 16/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class courseTableViewController: UITableViewController {

//    @IBOutlet weak var LoginSessionUnameLabel: UILabel!
    
    var sessionID :String!
    var sessionName : String!
    
    var count : Int = 0;
    
    var coursesTableArray = [String]()
    var problemTableArray = [problemTable]()


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogged")
        NSUserDefaults.standardUserDefaults().synchronize()
        performSegueWithIdentifier("loginView", sender: self)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isUserLogged") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("loginView", sender: self)
        } else {
            
            sessionName = prefs.valueForKey("USERNAME") as? String
            
            
            
            //------Get User ID
            var userId : NSDictionary!
            do {
                
                let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/GetUserId.php?username=\(sessionName)")!)
                userId = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                
            }
            catch{
                print(error)
            }
            
//            print("user id = \(userId)")
            
            sessionID = userId["id"] as? String
//            self.LoginSessionUnameLabel.text = sessionID
            
            prefs.setObject(sessionID, forKey: "SESSIONID")
            
            
            
            
            
//            print("SESSION ID = \(sessionID)")
            var result : NSArray!
            do {
                let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/Courses.php?userId=\(sessionID)")!)
                result = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                
            }
            catch{
                print(error)
            }
            
            //------To get Course Id[]
            var courseId : Array<String> = []
            for (index,element) in result.enumerate() {
                if (index % 2 == 0){
                    courseId.append(element as! String)
                }
            }
            
            //------To get Courses[]
            var courses : Array<String> = []
            for (index,element) in result.enumerate() {
                if (index % 2 != 0){
                    courses.append(element as! String)
                }
            }
            
            // print(courses)
            
            //print(courseId)
            coursesTableArray = courses                                                       //For Courses Cell
         
            //******************************************************************************************
            //--------------------------This part loads problemsArray[]---------------------------------
            //******************************************************************************************
            
            problemTableArray = []
            
            let lengthOfCoursesTableArray = coursesTableArray.count
            
            //print(lengthOfCoursesTableArray)
            
            
            for (var i = 0; i < lengthOfCoursesTableArray; i++)
            {
                //print(courseId[i])
                
                let id = courseId[i]
                
//                print(id)
                var problemsArray : NSArray!
                do {
                    
                    let data = NSData(contentsOfURL: NSURL(string: "http://10.100.9.105/vinoth/cloudcoder-db-trail/Problems.php?courseId=\(id)")!)
                    problemsArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                    
                }
                catch{
                    print(error)
                }
                
//                print(problemsArray)
                
                
                //------To get Problem Id[]
                var problemId : Array<String> = []
                for (index,element) in problemsArray.enumerate() {
                    if (index % 2 == 0){
                        problemId.append(element as! String)
                    }
                }
                
                //------To get Courses[]
                var problems : Array<String> = []
                for (index,element) in problemsArray.enumerate() {
                    if (index % 2 != 0){
                        problems.append(element as! String)
                    }
                }
                
                //------To append problems in problemTableArray[]
                let probs = problems
                let probsId = problemId
                
                let array = problemTable(problemTitle : probs, problemId : probsId)
                
                problemTableArray.append(array)
                
            }
            
            // print(problemTableArray)
    
        }

    }


    
    
    
    //******************************************************************************************
    //******************************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Courses")
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "update", userInfo: nil, repeats: true)
        
        print(timer)
        
    }
    //******************************************************************************************
    //******************************************************************************************

    
    //------It return no.of course(row)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return coursesTableArray.count;
    }
    
    //------It return individual cell for course
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let course = self.tableView.dequeueReusableCellWithIdentifier("Courses", forIndexPath: indexPath) as UITableViewCell
        
        course.textLabel?.text = coursesTableArray[indexPath.row]
        return course
    }
    
    //-------//Changes//---passing data to problemsTableViewController
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("problemsTable") as! problemsTableViewController
        
        var passProblemSegue : problemTable
        passProblemSegue = problemTableArray[indexPath.row]
        DestinationController.problemsTableArray = passProblemSegue.problemTitle    //Pass Title to problemsTableArray[]->(problemTableviewController)
        
        
        passProblemSegue = problemTableArray[indexPath.row]
        DestinationController.problemIdArray = passProblemSegue.problemId           //Pass Id to problemIdArray[]->(problemTableviewController)
        
        self.navigationController?.pushViewController(DestinationController, animated: true)
        
    }
    
    func update() {
        count++
        coursesTableArray.count
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}

