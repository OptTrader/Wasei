//
//  WalkthroughPageViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/28/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource
{
  var pageHeadings = ["Personalize", "Locate", "Explore"]
  var pageImages = ["intro-1", "intro-2", "intro-3"]
  var pageContent = ["Pin your favorite places and create your own guide",
    "Search and locate your favourite places on Maps",
    "Find places pinned by your friends and other people around the world"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the data source to itself
    dataSource = self
    
    // Create the first walkthrough screen
    if let startingViewController = viewControllerAtIndex(0)
    {
      setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
    }
    
  }
  
  // MARK: - UIPageViewControllerDataSource
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
  {
    var index = (viewController as! WalkthroughContentViewController).index
    index++
    
    return viewControllerAtIndex(index)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
  {
    var index = (viewController as! WalkthroughContentViewController).index
    index--
    
    return viewControllerAtIndex(index)
  }
  
  func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController?
  {
    if index == NSNotFound || index < 0 || index >= pageHeadings.count
    {
      return nil
    }
    
    // Create a new view controller and pass suitable data
    if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController") as? WalkthroughContentViewController
    {
      pageContentViewController.heading = pageHeadings[index]
      pageContentViewController.imageFile = pageImages[index]
      pageContentViewController.content = pageContent[index]
      pageContentViewController.index = index
      
      return pageContentViewController
    }
    
    return nil
  }
  
  func forward(index: Int)
  {
    if let nextViewController = viewControllerAtIndex(index + 1)
    {
      setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
    }
  }
  
}