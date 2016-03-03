//
//  problemsTableViewController.swift
//  CC_TableView
//
//  Created by KGISL-MAC on 05/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class problemsTableViewController: UITableViewController {
    
    var problemsTableArray = [String]()
    var problemIdArray = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //------IT  no.of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return problemsTableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let problem = self.tableView.dequeueReusableCellWithIdentifier("Problems", forIndexPath: indexPath) as UITableViewCell
        
        problem.textLabel?.text = problemsTableArray[indexPath.row]
        problem.detailTextLabel?.text = problemIdArray[indexPath.row]
        
        return problem
        
    }
    
    var valueToPass:String!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        valueToPass = currentCell.detailTextLabel!.text
    
        print(valueToPass)
        
        let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("sourceCodePage") as! sourcePageViewController
        
        DestinationController.pid = valueToPass
        
        self.navigationController?.pushViewController(DestinationController, animated: true)
        
    }


    
//        var valueToPass:String!
//    
//        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            print("You selected cell #\(indexPath.row)!")
//    
//            // Get Cell Label
//            let indexPath = tableView.indexPathForSelectedRow!;
//            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
//    
//            valueToPass = currentCell.detailTextLabel!.text
//            performSegueWithIdentifier("problemToSource", sender: self)
//
//            print(valueToPass)
//    
//        }
    

    
//        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    
//            if (segue.identifier == "problemTosource") {
//    
//                // initialize new view controller and cast it as your view controller
//                let viewController = segue.destinationViewController as! sourcePageViewController
//                // your new view controller should have property that will store passed value
//                viewController.passedValue = sourceCode
//                
//            }
//    
//        }
    

    
    
}
