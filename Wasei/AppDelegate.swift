//
//  AppDelegate.swift
//  Wasei
//
//  Created by Chris Kong on 10/23/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // Change the navigation bar's appearance
    UINavigationBar.appearance().barTintColor = UIColor(red: 239.0/255.0, green: 108.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    if let barFont = UIFont(name: "Avenir-Light", size: 21.0)
    {
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: barFont]
    }
    
    // Change the tab bar's appearance
    UITabBar.appearance().barTintColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    
    return true
  }


}