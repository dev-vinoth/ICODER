//
//  BaseViewController.swift
//  SlideMenu
//
//  Created by KGISL-MAC on 19/02/16.
//  Copyright © 2016 KGISL-MAC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            
            let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("courseStoryBoard") as! courseTableViewController
            self.navigationController?.pushViewController(DestinationController, animated: true)
//            self.presentViewController(DestinationController, animated: true, completion: nil )
            break
            
        case 1:
            
            let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("playGround") as! PlayGroundViewController
            self.navigationController?.pushViewController(DestinationController, animated: true)
            
            break
            
        case 2:
            let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("changePassword") as! changePasswordViewController
            self.navigationController?.pushViewController(DestinationController, animated: true)
            break
            
        case 3:
            let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! loginPageViewController
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogged")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.presentViewController(DestinationController, animated: true, completion: nil )
            break
            
        case 4:
            let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("feedback") as! feedbackViewController
            self.navigationController?.pushViewController(DestinationController, animated: true)
            break
        case 5:
            let DestinationController = self.storyboard?.instantiateViewControllerWithIdentifier("about") as! changePasswordViewController
            self.navigationController?.pushViewController(DestinationController, animated: true)
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func addSlideMenuButton(){
      
        let logButton : UIBarButtonItem = UIBarButtonItem(title: "|||", style: UIBarButtonItemStyle.Done, target: self, action: "onSlideMenuButtonPressed:")
    
        self.navigationItem.rightBarButtonItem = logButton
    }
    
    
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clearColor()
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        
        
        sender.enabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            menuVC.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
            sender.enabled = true
            }, completion:nil)
    }
}

