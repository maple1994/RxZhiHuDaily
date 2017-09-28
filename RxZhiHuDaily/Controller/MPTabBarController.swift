//
//  MPTabBarController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MPTabBarController: UITabBarController {

    var themeVC: MPThemeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = MPHomeViewController()
        themeVC = MPThemeViewController()
        let nav1 = MPNavigationViewController(rootViewController: homeVC)
        let nav2 = MPNavigationViewController(rootViewController: themeVC!)
        addChildViewController(nav1)
        addChildViewController(nav2)
        self.tabBar.isHidden = true
    }

}

