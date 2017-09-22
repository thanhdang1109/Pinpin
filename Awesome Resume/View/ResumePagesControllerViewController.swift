//
//  ResumePagesControllerViewController.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 6/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumePagesControllerViewController: UIPageViewController, UIPageViewControllerDataSource {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = dataSource
        // Do any additional setup after loading the view.
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }

}
