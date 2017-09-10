//
//  ResumesPagesVC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 6/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumesPagesVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageVC: UIPageViewController!
    let pages = ["pageMedia","pageResume"]
    
    // Page view datasource:Before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController.restorationIdentifier!){
            if index > 0{
                return viewControllerAtIndex(index: index-1)
            }else{
                return nil
            }
        }
        return nil
    }
    
    // Page view datasource:After
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController.restorationIdentifier!){
            if index < pages.count - 1 {
                return viewControllerAtIndex(index: index+1)
            }else{
                return nil
            }
        }
        return nil
    }
    
    // Function to return index of page
    func viewControllerAtIndex(index: Int) -> UIViewController{
        let vc = storyboard?.instantiateViewController(withIdentifier: pages[index])
        return vc!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ResumePagesVC"){
            
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
        
            pageVC = vc as! UIPageViewController
            pageVC.dataSource = self
            pageVC.delegate = self
            
            // Initialized with the first page view
            pageVC.setViewControllers([viewControllerAtIndex(index:1)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

            pageVC.didMove(toParentViewController: self)
        }
    }
    @IBOutlet weak var TopBar: UIToolbar!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
