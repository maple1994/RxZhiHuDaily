//
//  MPNewsDetailViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/10/11.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

/// 话题详情控制器
class MPNewsDetailViewController: UIViewController {

    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
}





