//
//  MPNavigationViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

class MPNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            self.slideMenuController()?.leftPanGesture?.isEnabled = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if self.childViewControllers.count == 2 {
            self.slideMenuController()?.leftPanGesture?.isEnabled = true
        }
        return super.popViewController(animated: animated)
    }
    
}
