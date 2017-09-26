//
//  MPTabBarController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

class MPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = MPHomeViewController()
        let otherVC = MPOtherTypeViewController()
        let nav1 = MPNavigationViewController(rootViewController: homeVC)
        let nav2 = MPNavigationViewController(rootViewController: otherVC)
        addChildViewController(nav1)
        addChildViewController(nav2)
        self.tabBar.isHidden = true
    }

}
